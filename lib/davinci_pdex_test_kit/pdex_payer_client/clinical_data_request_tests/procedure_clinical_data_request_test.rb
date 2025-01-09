require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexPayerClientSuite
    class PDexClientProcedureSubmitClinicalDataRequestTest < Inferno::Test
      include DaVinciPDexTestKit::ClientValidationTest
  
      id :pdex_procedure_clinical_data_request_test
      title 'Procedure resources related to the patient matched are gathered'
      description %(
        This test will look through all returned Procedure resources for a specific expected resource related to the matched patient.
      )
      input :access_token
  
  
      run do
        skip_if scratch[:Procedure].nil?, "No requests made for Procedure resources"
  
        assert scratch[:Procedure].any? {|resource| resource.id == 'pdex-Procedure'}, "Unable to find expected resource: pdex-Procedure" 
      end
    end
  end
end
