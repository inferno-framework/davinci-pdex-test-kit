require_relative '../../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientPatientSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :patient_clinical_data_request_test
    title 'Patient resources related to the patient matched are gathered'
    description %(
      This test will look through all returned Patient resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:Patient].nil?, "No requests made for Patient resources"

      assert scratch[:Patient].any? {|resource| resource.id = 'pdex-Patient'}, "Unable to find expected resource: 999" 
    end
  end
end
