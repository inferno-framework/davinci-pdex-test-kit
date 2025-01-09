require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexPayerClientSuite
    class PDexClientLocationSubmitClinicalDataRequestTest < Inferno::Test
      include DaVinciPDexTestKit::ClientValidationTest
  
      id :pdex_location_clinical_data_request_test
      title 'Location resources related to the patient matched are gathered'
      description %(
        This test will look through all returned Location resources for a specific expected resource related to the matched patient.
      )
      input :access_token
  
  
      run do
        skip_if scratch[:Location].nil?, "No requests made for Location resources"
  
        assert scratch[:Location].any? {|resource| resource.id == 'pdex-Location'}, "Unable to find expected resource: pdex-Location" 
      end
    end
  end
end
