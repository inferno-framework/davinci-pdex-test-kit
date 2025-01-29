require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientCareTeamSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_careteam_clinical_data_request_test
      title 'CareTeam resources related to the patient matched are gathered'
      description %(
        This test will look through all returned CareTeam resources for a specific expected resource related to the matched patient.
      )
      input :access_token
  
  
      run do
        load_clinical_data_into_scratch
        
        skip_if scratch[:CareTeam].nil?, "No requests made for CareTeam resources"
  
        assert scratch[:CareTeam].any? {|resource| resource.id == 'pdex-CareTeam'}, "Unable to find expected resource: pdex-CareTeam" 
      end
    end
  end
end
