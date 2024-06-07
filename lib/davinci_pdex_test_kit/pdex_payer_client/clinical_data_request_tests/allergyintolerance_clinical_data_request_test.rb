require_relative '../../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientAllergyIntoleranceSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :allergyintolerance_clinical_data_request_test
    title 'AllergyIntolerance resources related to the patient matched are gathered'
    description %(
      This test will look through all returned AllergyIntolerance resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:AllergyIntolerance].nil?, "No requests made for AllergyIntolerance resources"

      assert scratch[:AllergyIntolerance].any? {|resource| resource.id == 'pdex-AllergyIntolerance'}, "Unable to find expected resource: pdex-AllergyIntolerance" 
    end
  end
end
