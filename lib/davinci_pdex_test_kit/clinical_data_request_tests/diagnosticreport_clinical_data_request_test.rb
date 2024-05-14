require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientDiagnosticReportSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :diagnosticreport_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather DiagnosticReport resources related to the patient matched'
    description %(
      This test will look through all returned DiagnosticReport resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      requests = scratch["DiagnosticReportRequests".to_sym]
      skip_if scratch[:DiagnosticReport].nil?, "No requests made for DiagnosticReport resources"

      assert scratch[:DiagnosticReport].any? {|resource| resource.id = 'pdex-DiagnosticReport'}, "Unable to find expected resource: pdex-DiagnosticReport" 
    end
  end
end
