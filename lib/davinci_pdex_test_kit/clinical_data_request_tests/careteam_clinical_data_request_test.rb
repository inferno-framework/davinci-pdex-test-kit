require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientCareTeamSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :careteam_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather CareTeam resources related to the patient matched'
    description %(
      This test will look through all returned CareTeam resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      requests = scratch["CareTeamRequests".to_sym]
      skip_if scratch[:CareTeam].nil?, "No requests made for CareTeam resources"

      assert scratch[:CareTeam].any? {|resource| resource.id = 'pdex-CareTeam'}, "Unable to find expected resource: pdex-CareTeam" 
    end
  end
end
