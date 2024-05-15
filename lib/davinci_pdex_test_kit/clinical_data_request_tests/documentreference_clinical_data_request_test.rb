require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientDocumentReferenceSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :documentreference_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather DocumentReference resources related to the patient matched'
    description %(
      This test will look through all returned DocumentReference resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:DocumentReference].nil?, "No requests made for DocumentReference resources"

      assert scratch[:DocumentReference].any? {|resource| resource.id = 'pdex-DocumentReference'}, "Unable to find expected resource: pdex-DocumentReference" 
    end
  end
end
