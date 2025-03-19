require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module USCoreTestKit
  module USCoreV200
    class ExplanationOfBenefitIdentifierSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns valid results for ExplanationOfBenefit search by identifier'
      description %(
A server SHALL support searching by
identifier on the ExplanationOfBenefit resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](/CapabilityStatement-us-core-server.html)

      )

      id :us_core_v200_explanation_of_benefit_identifier_search_test
      optional
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'ExplanationOfBenefit',
        search_param_names: ['identifier'],
        token_search_params: ['identifier']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
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
