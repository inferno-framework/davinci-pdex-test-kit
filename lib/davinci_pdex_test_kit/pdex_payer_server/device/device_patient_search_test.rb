require 'us_core_test_kit/search_test'
require 'us_core_test_kit/search_test_properties'
require 'us_core_test_kit/generator/group_metadata'

module DaVinciPDexTestKit
  module PDexPayerServer
    class DevicePatientSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for Device search by patient'
      description %(
        A server SHALL support searching by
        patient on the Device resource. This test
        will pass if resources are returned and match the search criteria. If
        none are returned, the test is skipped.

        This test verifies that the server supports searching by reference using
        the form `patient=[id]` as well as `patient=Patient/[id]`. The two
        different forms are expected to return the same number of results. US
        Core requires that both forms are supported by PDex responders.

        Because this is the first search of the sequence, resources in the
        response will be used for subsequent tests.

        Additionally, this test will check that GET and POST search methods
        return the same number of results. Search by POST is required by the
        FHIR R4 specification, and these tests interpret search by GET as a
        requirement of PDex v2.0.0.

        [PDex Server CapabilityStatement](https://hl7.org/fhir/us/davinci-pdex/STU2/CapabilityStatement-pdex-server.html)
      )

      id :pdex_device_patient_search
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
          first_search: true,
          resource_type: 'Device',
          search_param_names: ['patient'],
          test_reference_variants: true,
          test_post_search: true
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
