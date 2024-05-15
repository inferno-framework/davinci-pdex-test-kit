require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientExplanationOfBenefitSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :explanationofbenefit_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather ExplanationOfBenefit resources related to the patient matched'
    description %(
      This test will look through all returned ExplanationOfBenefit resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:ExplanationOfBenefit].nil?, "No requests made for ExplanationOfBenefit resources"

      assert scratch[:ExplanationOfBenefit].any? {|resource| resource.id = 'pdex-ExplanationOfBenefit'}, "Unable to find expected resource: pdex-ExplanationOfBenefit" 
    end
  end
end
