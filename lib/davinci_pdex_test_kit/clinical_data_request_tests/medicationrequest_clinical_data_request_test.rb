require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientMedicationRequestSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :medicationrequest_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather MedicationRequest resources related to the patient matched'
    description %(
      This test will look through all returned MedicationRequest resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:MedicationRequest].nil?, "No requests made for MedicationRequest resources"

      assert scratch[:MedicationRequest].any? {|resource| resource.id = 'pdex-MedicationRequest'}, "Unable to find expected resource: pdex-MedicationRequest" 
    end
  end
end
