require_relative '../../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientConditionSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :pdex_condition_clinical_data_request_test
    title 'Condition resources related to the patient matched are gathered'
    description %(
      This test will look through all returned Condition resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:Condition].nil?, "No requests made for Condition resources"

      assert scratch[:Condition].any? {|resource| resource.id == 'pdex-Condition'}, "Unable to find expected resource: pdex-Condition" 
    end
  end
end
