require_relative '../../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientMedicationDispenseSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :medicationdispense_clinical_data_request_test
    title 'MedicationDispense resources related to the patient matched are gathered'
    description %(
      This test will look through all returned MedicationDispense resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      info "scratch keys: #{scratch.keys}"
      skip_if scratch[:MedicationDispense].nil?, "No requests made for MedicationDispense resources"

      assert scratch[:MedicationDispense].any? {|resource| resource.id == 'pdex-MedicationDispense'}, "Unable to find expected resource: pdex-MedicationDispense" 
    end
  end
end
