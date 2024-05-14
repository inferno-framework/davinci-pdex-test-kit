require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientEncounterSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :encounter_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather Encounter resources related to the patient matched'
    description %(
      This test will look through all returned Encounter resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      requests = scratch["EncounterRequests".to_sym]
      skip_if scratch[:Encounter].nil?, "No requests made for Encounter resources"

      assert scratch[:Encounter].any? {|resource| resource.id = 'pdex-Encounter'}, "Unable to find expected resource: pdex-Encounter" 
    end
  end
end
