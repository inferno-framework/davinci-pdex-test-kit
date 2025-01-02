require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientOrganizationSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_organization_clinical_data_request_test
      title 'Organization resources related to the patient matched are gathered'
      description %(
        This test will look through all returned Organization resources for a specific expected resource related to the matched patient.
      )
      input :access_token
  
  
      run do
        load_clinical_data_into_scratch
        
        skip_if scratch[:Organization].nil?, "No requests made for Organization resources"
  
        assert scratch[:Organization].any? {|resource| resource.id == 'pdex-Organization'}, "Unable to find expected resource: pdex-Organization" 
      end
    end
  end
end
