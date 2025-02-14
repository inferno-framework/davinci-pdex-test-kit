require 'us_core_test_kit/search_test'
require 'us_core_test_kit/search_test_properties'
require 'us_core_test_kit/generator/group_metadata'

module DaVinciPDexTestKit
  module PDexPayerServer
    class ExplanationOfBenefitPatientLastUpdatedSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for ExplanationOfBenefit search by patient + _lastUpdated'
      description %(
A server SHALL support searching by
patient + _lastUpdated on the ExplanationOfBenefit resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

This test verifies that the server supports searching by reference using
the form `patient=[id]` as well as `patient=Patient/[id]`. The two
different forms are expected to return the same number of results. US
Core requires that both forms are supported by US Core responders, and
PDex expands upon US Core.

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

Additionally, this test will check that GET and POST search methods
return the same number of results. Search by POST is required by the
FHIR R4 specification, and these tests interpret search by GET as a
requirement of PDex v2.0.0.

[PDex Server CapabilityStatement](https://hl7.org/fhir/us/davinci-pdex/STU2/CapabilityStatement-pdex-server.html)

      )

      id :pdex_eob_patient_last_updated_test

      input :patient_ids,
            title: 'Patient IDs',
            description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'

      def self.properties
        @properties ||= USCoreTestKit::SearchTestProperties.new(
          resource_type: 'ExplanationOfBenefit',
          search_param_names: ['patient', '_lastUpdated'],
          test_post_search: true
          # TODO: other properties?
        )
      end

      def self.metadata
        @metadata ||= USCoreTestKit::Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'),
                                                                                 aliases: true))
      end

      def scratch_resources
        scratch[:explanation_of_benefit_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
