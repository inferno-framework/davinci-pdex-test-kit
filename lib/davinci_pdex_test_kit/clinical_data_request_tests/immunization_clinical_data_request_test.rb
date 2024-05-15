require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientImmunizationSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :immunization_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather Immunization resources related to the patient matched'
    description %(
      This test will look through all returned Immunization resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:Immunization].nil?, "No requests made for Immunization resources"

      assert scratch[:Immunization].any? {|resource| resource.id = 'pdex-Immunization'}, "Unable to find expected resource: pdex-Immunization" 
    end
  end
end
