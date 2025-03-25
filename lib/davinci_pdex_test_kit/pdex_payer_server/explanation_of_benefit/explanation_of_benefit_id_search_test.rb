require 'us_core_test_kit/search_test'
require 'us_core_test_kit/search_test_properties'
require 'us_core_test_kit/generator/group_metadata'

module DaVinciPDexTestKit
  module PDexPayerServer
    class ExplanationOfBenefitIdSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for ExplanationOfBenefit search by _id'
      description %(
        A server SHALL support searching by
        _id on the ExplanationOfBenefit resource. This test
        will pass if resources are returned and match the search criteria. If
        none are returned, the test is skipped.

        [PDex Server CapabilityStatement](https://hl7.org/fhir/us/davinci-pdex/STU2/CapabilityStatement-pdex-server.html)
      )

      id :pdex_eob_id_search_test
      def self.properties
        @properties ||= USCoreTestKit::SearchTestProperties.new(
          resource_type: 'ExplanationOfBenefit',
          search_param_names: ['_id']
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
