require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientPractitionerSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :practitioner_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather Practitioner resources related to the patient matched'
    description %(
      This test will look through all returned Practitioner resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:Practitioner].nil?, "No requests made for Practitioner resources"

      assert scratch[:Practitioner].any? {|resource| resource.id = 'pdex-Practitioner'}, "Unable to find expected resource: pdex-Practitioner" 
    end
  end
end
