require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientEncounterSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_encounter_clinical_data_request_test
      title 'Encounter resources related to the patient matched are gathered'
      description %(
        This test will look through all returned Encounter resources for a specific expected resource related to the matched patient.
      )
      input :access_token
  
  
      run do
        load_clinical_data_into_scratch
        
        skip_if scratch[:Encounter].nil?, "No requests made for Encounter resources"
  
        assert scratch[:Encounter].any? {|resource| resource.id == 'pdex-Encounter'}, "Unable to find expected resource: pdex-Encounter" 
      end
    end
  end
end
