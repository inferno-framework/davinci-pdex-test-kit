require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientGoalSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_goal_clinical_data_request_test
      title 'Goal resources related to the patient matched are gathered'
      description %(
        This test will look through all returned Goal resources for a specific expected resource related to the matched patient.
      )
      input :access_token
  
  
      run do
        load_clinical_data_into_scratch
        
        skip_if scratch[:Goal].nil?, "No requests made for Goal resources"
  
        assert scratch[:Goal].any? {|resource| resource.id == 'pdex-Goal'}, "Unable to find expected resource: pdex-Goal" 
      end
    end
  end
end
