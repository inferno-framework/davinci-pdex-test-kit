require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientPractitionerRoleSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_practitionerrole_clinical_data_request_test
      title 'PractitionerRole resources related to the patient matched are gathered'
      description %(
        This test will look through all returned PractitionerRole resources for a specific expected resource related to the matched patient.
      )
      input :access_token
  
  
      run do
        load_clinical_data_into_scratch
        
        skip_if scratch[:PractitionerRole].nil?, "No requests made for PractitionerRole resources"
  
        assert scratch[:PractitionerRole].any? {|resource| resource.id == 'pdex-PractitionerRole'}, "Unable to find expected resource: pdex-PractitionerRole" 
      end
    end
  end
end
