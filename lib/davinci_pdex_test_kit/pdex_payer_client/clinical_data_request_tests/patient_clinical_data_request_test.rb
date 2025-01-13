require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientPatientSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_patient_clinical_data_request_test
      title 'Patient resources related to the patient matched are gathered'
      description %(
        This test will look through all returned Patient resources for a specific expected resource related to the matched patient.
      )
      input :access_token
  
  
      run do
        skip_if scratch[:Patient].nil?, "No requests made for Patient resources"
  
        assert scratch[:Patient].any? {|resource| resource.id == '999'}, "Unable to find expected resource: 999" 
      end
    end
  end
end
