require 'inferno/dsl/oauth_credentials'
require_relative '../../version'
require_relative '../../custom_groups/v2.0.0/capability_statement_group'
require_relative '../../custom_groups/v4.0.0/clinical_notes_guidance_group'
require_relative '../../custom_groups/data_absent_reason_group'
require_relative '../../custom_groups/smart_app_launch_group'
require_relative '../../provenance_validator'
require_relative '../../us_core_options'

require_relative 'device_group'
require_relative 'explanation_of_benefit_group'
require_relative 'medication_dispense_group'
require_relative 'provenance_group'

module DaVinciPDexTestKit
  module PDexPayerServer
    class USCoreTestSuite < Inferno::TestSuite
      title 'PDex v2.0.0'
      description %(
        The PDex Test Kit tests systems for their conformance to the [PDex
        Implementation Guide]().

        HL7® FHIR® resources are validated with the Java validator using
        `tx.fhir.org` as the terminology server. Users should note that the
        although the ONC Certification (g)(10) Standardized API Test Suite
        includes tests from this suite, [it uses a different method to perform
        terminology
        validation](https://github.com/onc-healthit/onc-certification-g10-test-kit/wiki/FAQ#q-why-do-some-resources-fail-in-us-core-test-kit-with-terminology-validation-errors).
        As a result, resource validation results may not be consistent between
        the PDex Test Suite and the ONC Certification (g)(10) Standardized
        API Test Suite.
      )

      GENERAL_MESSAGE_FILTERS = [
        %r{Sub-extension url 'introspect' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        %r{Sub-extension url 'revoke' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        /Observation\.effective\.ofType\(Period\): .*vs-1:/, # Invalid invariant in FHIR v4.0.1
        /Observation\.effective\.ofType\(Period\): .*us-core-1:/, # Invalid invariant in PDex v3.1.1
        /Provenance.agent\[\d*\]: Constraint failed: provenance-1/, # Invalid invariant in PDex v5.0.1
        %r{Unknown Code System 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags'}, # Validator has an issue with this PDex 5 code system in PDex 6 resource
        %r{URL value 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags' does not resolve}, # Validator has an issue with this PDex 5 code system in PDex 6 resource
        /\A\S+: \S+: URL value '.*' does not resolve/,
        %r{Observation.component\[\d+\].value.ofType\(Quantity\): The code provided \(http://unitsofmeasure.org#L/min\) was not found in the value set 'Vital Signs Units'}, # Known issue with the Pulse Oximetry Profile
        %r{Slice 'Observation\.value\[x\]:valueQuantity': a matching slice is required, but not found \(from (http://hl7\.org/fhir/StructureDefinition/bmi\|4\.0\.1|http://hl7\.org/fhir/StructureDefinition/bmi%7C4\.0\.1)\)}
      ].freeze

      VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

      VALIDATION_MESSAGE_FILTERS = GENERAL_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

      def self.metadata
        @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
          Generator::GroupMetadata.new(raw_metadata)
        end
      end

      id :us_core_v200

      fhir_resource_validator do
        igs 'hl7.fhir.us.core#2.0.0'
        message_filters = VALIDATION_MESSAGE_FILTERS

        exclude_message do |message|
          message_filters.any? { |filter| filter.match? message.message }
        end

        perform_additional_validation do |resource, profile_url|
          ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
        end
      end

      input :url,
            title: 'FHIR Endpoint',
            description: 'URL of the FHIR endpoint'

      suite_option :smart_app_launch_version,
                   title: 'SMART App Launch Version',
                   default: USCoreOptions::SMART_2,
                   list_options: [
                     {
                       label: 'SMART App Launch 1.0.0',
                       value: USCoreOptions::SMART_1
                     },
                     {
                       label: 'SMART App Launch 2.0.0',
                       value: USCoreOptions::SMART_2
                     },
                     {
                       label: 'SMART App Launch 2.2.0',
                       value: USCoreOptions::SMART_2_2
                     }
                   ]

      group from: :us_core_smart_app_launch

      group do
        input :smart_credentials,
              title: 'OAuth Credentials',
              type: :oauth_credentials,
              optional: true

        fhir_client do
          url :url
          oauth_credentials :smart_credentials
        end

        title 'PDex FHIR API'
        id :pdex_fhir_api

        group from: :pdex_capability_statement

        group from: :pdex_device
        group from: :pdex_eob
        group from: :pdex_medication_dispense
        group from: :pdex_provenance
        group from: :us_core_v400_clinical_notes_guidance
        group from: :us_core_311_data_absent_reason
      end

      links [
        {
          type: 'report_issue',
          label: 'Report Issue',
          url: 'https://github.com/inferno-framework/us-core-test-kit/issues/'
        },
        {
          type: 'source_code',
          label: 'Open Source',
          url: 'https://github.com/inferno-framework/us-core-test-kit/'
        },
        {
          type: 'download',
          label: 'Download',
          url: 'https://github.com/inferno-framework/us-core-test-kit/releases/'
        }
      ]
    end
  end
end
