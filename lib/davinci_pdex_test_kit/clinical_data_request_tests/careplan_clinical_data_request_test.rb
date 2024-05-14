require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientCarePlanSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :careplan_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather CarePlan resources related to the patient matched'
    description %(
      This test will look through all returned CarePlan resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      requests = scratch["CarePlanRequests".to_sym]
      skip_if scratch[:CarePlan].nil?, "No requests made for CarePlan resources"

      assert scratch[:CarePlan].any? {|resource| resource.id = 'pdex-CarePlan'}, "Unable to find expected resource: pdex-CarePlan" 
    end
  end
end
