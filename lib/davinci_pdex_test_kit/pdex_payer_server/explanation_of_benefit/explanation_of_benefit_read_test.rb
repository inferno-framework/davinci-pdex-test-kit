require 'us_core_test_kit/read_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class ExplanationOfBenefitReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct ExplanationOfBenefit resource from ExplanationOfBenefit read interaction'
      description 'A server SHALL support the ExplanationOfBenefit read interaction.'

      id :pdex_eob_read_test

      def resource_type
        'ExplanationOfBenefit'
      end

      def scratch_resources
        scratch[:explanation_of_benefit_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
