require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientExplanationOfBenefitSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_explanationofbenefit_clinical_data_request_test
      title 'ExplanationOfBenefit resources related to the patient matched are gathered'
      description %(
        This test will look through all returned ExplanationOfBenefit resources for a specific expected resource related to the matched patient.
      )
      input :access_token
  
  
      run do
        load_clinical_data_into_scratch
        
        skip_if scratch[:ExplanationOfBenefit].nil?, "No requests made for ExplanationOfBenefit resources"
  
        assert scratch[:ExplanationOfBenefit].any? {|resource| resource.id == 'pdex-ExplanationOfBenefit'}, "Unable to find expected resource: pdex-ExplanationOfBenefit" 
      end
    end
  end
end
