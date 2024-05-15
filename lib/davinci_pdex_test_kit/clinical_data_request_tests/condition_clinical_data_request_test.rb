require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientConditionSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :condition_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather Condition resources related to the patient matched'
    description %(
      This test will look through all returned Condition resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:Condition].nil?, "No requests made for Condition resources"

      assert scratch[:Condition].any? {|resource| resource.id = 'pdex-Condition'}, "Unable to find expected resource: pdex-Condition" 
    end
  end
end
