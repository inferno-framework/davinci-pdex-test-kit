# must_support.rb
# This file was borrowed from the US Core Generator.

require_relative 'fhir_resource_navigation'

module DaVinciPDexTestKit
  module MustSupportTest
    extend Forwardable
    include FHIRResourceNavigation

    def_delegators 'self.class', :metadata

    def all_scratch_resources
      scratch_resources[:all] ||= []
    end

    def tagged_resources(tag)
      resources = []
      load_tagged_requests(tag)
      return resources if requests.empty?

      requests.each do |req|
        begin
          bundle = FHIR.from_contents(req.request_body)
        rescue StandardError
          next
        end

        next unless bundle.is_a?(FHIR::Bundle)

        resources << bundle
        entry_resources = bundle.entry.map(&:resource)
        resources.concat(entry_resources)
      end

      resources
    end

    def all_must_support_errors
      @all_must_support_errors ||= []
    end

    def validate_must_support
      assert all_must_support_errors.empty?, all_must_support_errors.join("\n")
    end

    def perform_must_support_test(resources)
      assert resources.present?, "No #{resource_type} resources were found"

      missing_elements(resources)
      missing_slices(resources)
      missing_extensions(resources)

      handle_must_support_choices if metadata.must_supports[:choices].present?

      return unless (missing_elements + missing_slices + missing_extensions).compact.reject(&:empty?).present?

      pass if (missing_elements + missing_slices + missing_extensions).empty?
      assert false, "Could not find #{missing_must_support_strings.join(', ')} in the #{resources.length} " \
                    "provided #{resource_type} resource(s)"
    end

    def handle_must_support_choices
      missing_elements.delete_if do |element|
        choices = metadata.must_supports[:choices].find { |choice| choice[:paths]&.include?(element[:path]) }
        is_any_choice_supported?(choices)
      end

      missing_extensions.delete_if do |extension|
        choices = metadata.must_supports[:choices].find { |choice| choice[:extension_ids]&.include?(extension[:id]) }
        is_any_choice_supported?(choices)
      end

      missing_slices.delete_if do |slice|
        choices = metadata.must_supports[:choices].find { |choice| choice[:slice_names]&.include?(slice[:slice_id]) }
        is_any_choice_supported?(choices)
      end
    end

    def is_any_choice_supported?(choices)
      choices.present? &&
        (
          choices[:paths]&.any? { |path| missing_elements.none? { |element| element[:path] == path } } ||
          choices[:extension_ids]&.any? do |extension_id|
            missing_extensions.none? do |extension|
              extension[:id] == extension_id
            end
          end ||
          choices[:slice_names]&.any? { |slice_name| missing_slices.none? { |slice| slice[:slice_id] == slice_name } }
        )
    end

    def missing_must_support_strings
      missing_elements.map { |element_definition| missing_element_string(element_definition) } +
        missing_slices.map { |slice_definition| slice_definition[:slice_id] } +
        missing_extensions.map { |extension_definition| extension_definition[:id] }
    end

    def missing_element_string(element_definition)
      if element_definition[:fixed_value].present?
        "#{element_definition[:path]}:#{element_definition[:fixed_value]}"
      else
        element_definition[:path]
      end
    end

    def exclude_uscdi_only_test?
      config.options[:exclude_uscdi_only_test] == true
    end

    def must_support_extensions
      if exclude_uscdi_only_test?
        metadata.must_supports[:extensions].reject { |extension| extension[:uscdi_only] }
      else
        metadata.must_supports[:extensions]
      end
    end

    def missing_extensions(resources = [])
      @missing_extensions ||=
        must_support_extensions.select do |extension_definition|
          resources.none? do |resource|
            path = extension_definition[:path]
            if extension_definition[:path] == 'extension'
              resource.extension.any? { |extension| extension.url == extension_definition[:url] }
            else
              extension = find_a_value_at(resource, path) do |el|
                el.url == extension_definition[:url]
              end

              extension&.url == extension_definition[:url]
            end
          end
        end
    end

    def must_support_elements
      if exclude_uscdi_only_test?
        metadata.must_supports[:elements].reject { |element| element[:uscdi_only] }
      else
        metadata.must_supports[:elements]
      end
    end

    def missing_elements(resources = [])
      @missing_elements ||=
        must_support_elements.select do |element_definition|
          # PAS: The MS Claim.supportingInfo slices do not have timing[x]
          next if resource_type == 'Claim' && element_definition[:path] == 'supportingInfo.timing[x]'

          resources.none? do |resource|
            path = element_definition[:path] # .delete_suffix('[x]')
            value_found = find_a_value_at(resource, path) do |value|
              value_without_extensions =
                value.respond_to?(:to_hash) ? value.to_hash.except('extension') : value

              (value_without_extensions.present? || value_without_extensions == false) &&
                (element_definition[:fixed_value].blank? || value == element_definition[:fixed_value])
            end
            # Note that false.present? => false, which is why we need to add this extra check
            value_found.present? || value_found == false
          end
        end
      @missing_elements.compact
    end

    def must_support_slices
      metadata.must_supports[:slices]
    end

    def missing_slices(resources = [])
      @missing_slices ||=
        must_support_slices.select do |slice|
          resources.none? do |resource|
            path = slice[:path] # .delete_suffix('[x]')
            find_slice(resource, path, slice[:discriminator]).present?
          end
        end
    end

    def find_slice(resource, path, discriminator)
      find_a_value_at(resource, path) do |element|
        case discriminator[:type]
        when 'patternCodeableConcept'
          coding_path = discriminator[:path].present? ? "#{discriminator[:path]}.coding" : 'coding'
          find_a_value_at(element, coding_path) do |coding|
            coding.code == discriminator[:code] && coding.system == discriminator[:system]
          end
        when 'patternCoding'
          coding_path = discriminator[:path].present? ? discriminator[:path] : ''
          find_a_value_at(element, coding_path) do |coding|
            coding.code == discriminator[:code] && coding.system == discriminator[:system]
          end
        when 'patternIdentifier'
          find_a_value_at(element, discriminator[:path]) { |identifier| identifier.system == discriminator[:system] }
        when 'value'
          values = discriminator[:values].map { |value| value.merge(path: value[:path].split('.')) }
          find_slice_by_values(element, values)
        when 'type'
          case discriminator[:code]
          when 'Date'
            begin
              Date.parse(element)
            rescue ArgumentError
              false
            end
          when 'DateTime'
            begin
              DateTime.parse(element)
            rescue ArgumentError
              false
            end
          when 'String'
            element.is_a? String
          else
            res = element.try(:resource) || element
            res.is_a? FHIR.const_get(discriminator[:code])
          end
        when 'requiredBinding'
          coding_path = discriminator[:path].present? ? "#{discriminator[:path]}.coding" : 'coding'
          find_a_value_at(element, coding_path) { |coding| discriminator[:values].include?(coding.code) }
        end
      end
    end

    def find_slice_by_values(element, value_definitions)
      path_prefixes = value_definitions.map { |value_definition| value_definition[:path].first }.uniq
      Array.wrap(element).find do |el|
        path_prefixes.all? do |path_prefix|
          value_definitions_for_path =
            value_definitions
              .select { |value_definition| value_definition[:path].first == path_prefix }
              .each { |value_definition| value_definition[:path].shift }
          find_a_value_at(el, path_prefix) do |el_found|
            child_element_value_definitions, current_element_value_definitions =
              value_definitions_for_path.partition { |value_definition| value_definition[:path].present? }
            current_element_values_match = current_element_value_definitions.all? do |value_definition|
              (value_definition[:value].present? && value_definition[:value] == el_found) ||
                (value_definition[:value].blank? && el_found.present?)
            end

            child_element_values_match =
              if child_element_value_definitions.present?
                find_slice_by_values(el_found, child_element_value_definitions)
              else
                true
              end
            
            current_element_values_match && child_element_values_match
          end
        end
      end
    end
  end
end
