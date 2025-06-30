require 'us_core_test_kit/search_test'
require 'us_core_test_kit/search_test_properties'
require 'us_core_test_kit/generator/group_metadata'

module DaVinciPDexTestKit
  module PDexPayerServer
    class MedicationDispensePatientStatusTypeSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for MedicationDispense search by patient + status + type'
      description %(
        A server SHOULD support searching by
        patient + status + type on the MedicationDispense resource. This test
        will pass if resources are returned and match the search criteria. If
        none are returned, the test is skipped.

        If any MedicationDispense resources use external references to
        Medications, the search will be repeated with
        `_include=MedicationDispense:medication`.

        [PDex Server CapabilityStatement](https://hl7.org/fhir/us/davinci-pdex/STU2/CapabilityStatement-pdex-server.html)
      )

      id :pdex_medication_dispense_patient_status_type_search
      optional

      input :patient_ids,
            title: 'Patient IDs',
            description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'

      def self.properties
        @properties ||= USCoreTestKit::SearchTestProperties.new(
          resource_type: 'MedicationDispense',
          search_param_names: ['patient', 'status', 'type'],
          test_medication_inclusion: true,
          token_search_params: ['type'],
          multiple_or_search_params: ['status', 'type']
        )
      end

      def self.metadata
        @metadata ||= USCoreTestKit::Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'),
                                                                                 aliases: true))
      end

      def scratch_resources
        scratch[:medication_dispense_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
