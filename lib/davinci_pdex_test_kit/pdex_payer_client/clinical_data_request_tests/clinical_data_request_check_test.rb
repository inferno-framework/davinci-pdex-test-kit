require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientClinicalDataRequestCheckTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_clinical_data_request_check
      title 'Check for Clinical Data Requests'
      description %(
        This test will check that clinical data requests were made and that
        at least some of them returned data for evaluation.
      )

      run do
        load_clinical_data_into_scratch

        assert requests.length > 0, 'No clinical requests received by Inferno.'
        assert scratch&.length > 0,
               'No clinical data requests made by the client returned any data.'
      end
    end
  end
end
