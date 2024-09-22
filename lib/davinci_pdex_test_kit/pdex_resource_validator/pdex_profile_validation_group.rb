require_relative 'pdex_json_validation'
require_relative 'pdex_resource_validation'
require_relative 'pdex_profile_validation'

module DaVinciPDexTestKit
  module PDexResourceValidator

    # Group for full profile validation on PDex v2.1.0 and HRex 1.1.0. FOR IMPORTING.
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
    #
    # ==== Required Scratch
    #
    # (none)
    #
    # ==== Notes
    #
    # See pdex_profile_validation_suite.rb for an example.
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
        title: config.options[:profile_name]

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
