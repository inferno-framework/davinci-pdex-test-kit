require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientProcedureSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :procedure_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather Procedure resources related to the patient matched'
    description %(
      This test will look through all returned Procedure resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      requests = scratch["ProcedureRequests".to_sym]
      skip_if scratch[:Procedure].nil?, "No requests made for Procedure resources"

      assert scratch[:Procedure].any? {|resource| resource.id = 'pdex-Procedure'}, "Unable to find expected resource: pdex-Procedure" 
    end
  end
end
