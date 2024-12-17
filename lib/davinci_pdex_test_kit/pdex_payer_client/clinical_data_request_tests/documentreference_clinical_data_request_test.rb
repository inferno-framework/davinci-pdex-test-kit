require_relative '../../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientDocumentReferenceSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :pdex_documentreference_clinical_data_request_test
    title 'DocumentReference resources related to the patient matched are gathered'
    description %(
      This test will look through all returned DocumentReference resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:DocumentReference].nil?, "No requests made for DocumentReference resources"

      assert scratch[:DocumentReference].any? {|resource| resource.id == 'pdex-DocumentReference'}, "Unable to find expected resource: pdex-DocumentReference" 
    end
  end
end
