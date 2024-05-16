require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientCarePlanSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :careplan_clinical_data_request_test
    title 'CarePlan resources related to the patient matched are gathered'
    description %(
      This test will look through all returned CarePlan resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:CarePlan].nil?, "No requests made for CarePlan resources"

      assert scratch[:CarePlan].any? {|resource| resource.id = 'pdex-CarePlan'}, "Unable to find expected resource: pdex-CarePlan" 
    end
  end
end
