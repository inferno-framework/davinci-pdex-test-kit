require_relative '../../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientImmunizationSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :immunization_clinical_data_request_test
    title 'Immunization resources related to the patient matched are gathered'
    description %(
      This test will look through all returned Immunization resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      info "scratch keys: #{scratch.keys}"
      skip_if scratch[:Immunization].nil?, "No requests made for Immunization resources"

      assert scratch[:Immunization].any? {|resource| resource.id == 'pdex-Immunization'}, "Unable to find expected resource: pdex-Immunization" 
    end
  end
end
