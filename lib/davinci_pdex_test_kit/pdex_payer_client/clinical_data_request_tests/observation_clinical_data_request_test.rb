require_relative '../../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientObservationSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :observation_clinical_data_request_test
    title 'Observation resources related to the patient matched are gathered'
    description %(
      This test will look through all returned Observation resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:Observation].nil?, "No requests made for Observation resources"

      assert scratch[:Observation].any? {|resource| resource.id == 'pdex-Observation'}, "Unable to find expected resource: pdex-Observation" 
    end
  end
end
