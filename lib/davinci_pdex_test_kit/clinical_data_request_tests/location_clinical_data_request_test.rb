require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientLocationSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :location_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather Location resources related to the patient matched'
    description %(
      This test will look through all returned Location resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      requests = scratch["LocationRequests".to_sym]
      skip_if scratch[:Location].nil?, "No requests made for Location resources"

      assert scratch[:Location].any? {|resource| resource.id = 'pdex-Location'}, "Unable to find expected resource: pdex-Location" 
    end
  end
end
