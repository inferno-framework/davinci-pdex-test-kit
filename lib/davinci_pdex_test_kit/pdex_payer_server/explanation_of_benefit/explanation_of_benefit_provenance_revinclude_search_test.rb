require 'us_core_test_kit/search_test'
require 'us_core_test_kit/search_test_properties'
require 'us_core_test_kit/generator/group_metadata'

module USCoreTestKit
  module USCoreV311
    class ExplanationOfBenefitProvenanceRevincludeSearchTest < Inferno::Test
      include USCoreTestKit::SearchTest

      title 'Server returns Provenance resources from ExplanationOfBenefit search by patient + revInclude:Provenance:target'
      description %(
        A server SHALL be capable of supporting _revIncludes:Provenance:target.

        This test will perform a search by patient + revInclude:Provenance:target and
        will pass if a Provenance resource is found in the response.
      %)

      id :pdex_eob_provenance_revinclude

      input :patient_ids,
            title: 'Patient IDs',
            description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements'

      def properties
        @properties ||= USCoreTestKit::SearchTestProperties.new(
          resource_type: 'ExplanationOfBenefit',
          search_param_names: ['patient']
        )
      end

      def self.metadata
        @metadata ||= USCoreTestKit::Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.provenance_metadata
        @provenance_metadata ||= USCoreTestKit::Generator::GroupMetadata.new(YAML.load_file(
                                                                               File.join(__dir__, '..', 'provenance',
                                                                                         'metadata.yml'), aliases: true
                                                                             ))
      end

      def scratch_resources
        scratch[:explanation_of_benefit_resources] ||= {}
      end

      def scratch_provenance_resources
        scratch[:provenance_resources] ||= {}
      end

      run do
        run_provenance_revinclude_search_test
      end
    end
  end
end
