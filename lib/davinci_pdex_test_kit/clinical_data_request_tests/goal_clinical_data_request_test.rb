require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientGoalSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :goal_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather Goal resources related to the patient matched'
    description %(
      This test will look through all returned Goal resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      requests = scratch["GoalRequests".to_sym]
      skip_if scratch[:Goal].nil?, "No requests made for Goal resources"

      assert scratch[:Goal].any? {|resource| resource.id = 'pdex-Goal'}, "Unable to find expected resource: pdex-Goal" 
    end
  end
end
