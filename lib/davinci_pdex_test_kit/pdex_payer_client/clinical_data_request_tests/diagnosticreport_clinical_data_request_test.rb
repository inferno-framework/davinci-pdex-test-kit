require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientDiagnosticReportSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_diagnosticreport_clinical_data_request
      title 'DiagnosticReport resources related to the patient matched are gathered'
      description %(
        This test verify that the expected instances of resource type DiagnosticReport
        were fetched by the client.
      )

      def target_resource_type
        :DiagnosticReport
      end
  
      run do
        check_resource_type_fetched_instances(target_resource_type)
      end
    end
  end
end
