require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientPatientIdSearchRequestCheckTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_patient_id_search_request_check_test
      title 'Check for Patient Id Search'
      description %(
        This test will check that a Patient search was made to get the Patient's
        resource `id` using the `identifier` returned by `$member-match`.
      )

      run do
        assert all_patient_id_search_requests.length > 0, 
               'Patient Id not requested using the identifier returned by `$member-match`.'
      end
    end
  end
end
