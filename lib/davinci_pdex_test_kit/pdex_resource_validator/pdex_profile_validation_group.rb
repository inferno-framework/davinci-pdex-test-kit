require_relative 'pdex_json_validation'
require_relative 'pdex_resource_validation'
require_relative 'pdex_profile_validation'

module DaVinciPDexTestKit
  module PDexResourceValidator

    # Group for full profile validation on PDex v2.1.0 and HRex 1.1.0
    #
    # ==== Inputs
    # 
    # input is config.options[:resource_type] in snake case
    #
    # ==== Outputs
    #
    # (none)
    #
    # ==== Required Config
    # 
    # +title+             - *Optional:* String
    # +short_title+       - *Optional:* String
    # +description+       - *Optional:* Markdown String
    # +resource_type+     - FHIR resource type as String
    # +profile_name+      - Human-friendly profile name
    # +profile_url+       - FHIR canonical profile url
    # +input_title+       - *Optional:* String
    # +input_description+ - *Optional:* String
    # +input_required+    - *Optional:* Boolean; by default all inputs are optional
    #
    # ==== Required Scratch
    #
    # (none)
    #
    # ==== Notes
    #
    # (none)
    #
    class PDexProfileValidationGroup < Inferno::TestGroup
      id :pdex_profile_validation_group

      def self.title
        config.options[:title].presence || "#{config.options[:profile_name]} Profile Validation Group"
      end

      def self.short_title
        config.options[:short_title]
      end

      def self.description
        config.options[:description]
      end

      input :target,
        type: 'textarea',
        title: config.options[:input_title].presence || config.options[:profile_name],
        description: config.options[:input_description].presence || "JSON text",
        optional: !config.options[:input_required]

      test from: :pdex_json_validation,
           id: :pdex_json_test,
           config: {
             inputs: {
               target: { name: :target }
             }
           }
  
      test from: :pdex_resource_validation,
        id: :pdex_resource_test,
        config: {
          inputs: {
            target: { name: :target }
          },
          options: {
            resource_type: config.options[:resource_type]
          }
        }

      test from: :pdex_profile_validation,
        id: :pdex_profile_test,
        config: {
          inputs: {
            target: { name: :target }
          },
          options: {
            profile_name: config.options[:profile_name],
            profile_url: config.options[:profile_url]
          }
        }

    end
  end
end
