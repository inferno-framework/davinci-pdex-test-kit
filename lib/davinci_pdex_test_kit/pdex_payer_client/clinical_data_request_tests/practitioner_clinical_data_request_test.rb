require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientPractitionerSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_practitioner_clinical_data_request_test
      title 'Practitioner resources related to the patient matched are gathered'
      description %(
        This test will look through all returned Practitioner resources for a specific expected resource related to the matched patient.
      )
      input :access_token
  
  
      run do
        skip_if scratch[:Practitioner].nil?, "No requests made for Practitioner resources"
  
        assert scratch[:Practitioner].any? {|resource| resource.id == 'pdex-Practitioner'}, "Unable to find expected resource: pdex-Practitioner" 
      end
    end
  end
end
