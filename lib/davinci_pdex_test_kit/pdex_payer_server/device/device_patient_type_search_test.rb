require 'us_core_test_kit/search_test'
require 'us_core_test_kit/generator/group_metadata'

module DaVinciPDexTestKit
  module PDexPayerServer
    class DevicePatientTypeSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Device search by patient + type'
      description %(
        A server SHOULD support searching by
        patient + type on the Device resource. This test
        will pass if resources are returned and match the search criteria. If
        none are returned, the test is skipped.

        [PDex Server CapabilityStatement](https://hl7.org/fhir/us/davinci-pdex/STU2/CapabilityStatement-pdex-server.html)
      )

      id :pdex_device_patient_type_search_test
      optional

      input :patient_ids,
            title: 'Patient IDs',
            description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'

      input :implantable_device_codes,
            title: 'Implantable Device Type Code',
            description: 'Enter the code for an Implantable Device type, or multiple codes separated by commas. ' \
                         'If blank, Inferno will validate all Device resources against the Implantable Device profile',
            optional: true

      def self.properties
        @properties ||= USCoreTestKit::SearchTestProperties.new(
          resource_type: 'Device',
          search_param_names: ['patient', 'type'],
          token_search_params: ['type']
        )
      end

      def self.metadata
        @metadata ||= USCoreTestKit::Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'),
                                                                                 aliases: true))
      end

      def scratch_resources
        scratch[:device_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
