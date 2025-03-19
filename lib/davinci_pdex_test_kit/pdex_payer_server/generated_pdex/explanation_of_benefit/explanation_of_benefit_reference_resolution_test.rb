require_relative '../../../reference_resolution_test'

module USCoreTestKit
  module USCoreV200
    class ExplanationOfBenefitReferenceResolutionTest < Inferno::Test
      include USCoreTestKit::ReferenceResolutionTest

      title 'MustSupport references within ExplanationOfBenefit resources are valid'
      description %(
        This test will attempt to read external references provided within elements
        marked as 'MustSupport', if any are available.

        It verifies that at least one external reference for each MustSupport Reference element
        can be accessed by the test client, and conforms to corresponding US Core profile.

        Elements which may provide external references include:

        * ExplanationOfBenefit.careTeam.provider
        * ExplanationOfBenefit.enterer
        * ExplanationOfBenefit.facility
        * ExplanationOfBenefit.insurer
        * ExplanationOfBenefit.patient
        * ExplanationOfBenefit.provider
      )

      id :us_core_v200_explanation_of_benefit_reference_resolution_test

      def resource_type
        'ExplanationOfBenefit'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:explanation_of_benefit_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
