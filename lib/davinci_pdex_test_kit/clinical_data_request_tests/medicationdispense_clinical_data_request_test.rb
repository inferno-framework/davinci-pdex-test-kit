require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientMedicationDispenseSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :medicationdispense_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather MedicationDispense resources related to the patient matched'
    description %(
      This test will look through all returned MedicationDispense resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:MedicationDispense].nil?, "No requests made for MedicationDispense resources"

      assert scratch[:MedicationDispense].any? {|resource| resource.id = 'pdex-MedicationDispense'}, "Unable to find expected resource: pdex-MedicationDispense" 
    end
  end
end
