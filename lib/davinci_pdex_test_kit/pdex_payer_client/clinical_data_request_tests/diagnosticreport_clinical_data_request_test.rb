require_relative '../../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientDiagnosticReportSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :diagnosticreport_clinical_data_request_test
    title 'DiagnosticReport resources related to the patient matched are gathered'
    description %(
      This test will look through all returned DiagnosticReport resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:DiagnosticReport].nil?, "No requests made for DiagnosticReport resources"

      assert scratch[:DiagnosticReport].any? {|resource| resource.id = 'pdex-DiagnosticReport'}, "Unable to find expected resource: pdex-DiagnosticReport" 
    end
  end
end
