require 'tls_test_kit'

# require 'bulk_data_test_kit/v1.0.1/bulk_data_export_operation_support_test'
require 'bulk_data_test_kit/v1.0.1/bulk_data_no_auth_test'
require 'bulk_data_test_kit/v1.0.1/bulk_data_export_kick_off_test'
require 'bulk_data_test_kit/v1.0.1/bulk_data_status_check_test'
require 'bulk_data_test_kit/v1.0.1/bulk_data_output_check_test'

require_relative 'patient_operation_in_capability_statement_validation'

module DaVinciPDexTestKit
  module PDexPayerServer
    class ExportPatientGroup < Inferno::TestGroup
      title 'Patient Export Tests'
      short_description 'Verify that the system supports bulk export of Patient Data'
      description <<~DESCRIPTION
        Verify that patient level export on the Bulk Data server follow the Bulk Data Access Implementation Guide
      DESCRIPTION
      id :pdex_patient_export_group
      optional

      run_as_group

      input :bearer_token,
            title: 'Bulk Data Authorization Bearer Token',
            description: 'The authorization bearer token for the Bulk FHIR server. If not required, leave blank.',
            optional: true
      input :bulk_timeout,
            title: 'Export Times Out after (1-600)',
            description: <<~DESCRIPTION,
              While testing, Inferno waits for the server to complete the exporting task. If the calculated totalTime is
              greater than the timeout value specified here, Inferno bulk client stops testing. Please enter an integer
              for the maximum wait time in seconds. If timeout is less than 1, Inferno uses default value 180. If the
                timeout is greater than 600 (10 minutes), Inferno uses the maximum value 600.
            DESCRIPTION
            default: 180

      output :patient_requires_access_token, :patient_status_output, :patient_bulk_download_url

      test from: :pdex_patient_operation_in_capability_statement_validation,
           id: :pdex_patient_export_in_capability_statement_test,
           title: 'Bulk Data Server declares support for Patient export operation in CapabilityStatement',
           config: {
             options: { operation_name: 'export', operation_url: 'http://hl7.org/fhir/uv/bulkdata/OperationDefinition/patient-export' }
           }

      test from: :bulk_data_kick_off,
           id: :pdex_export_patient_kick_off,
           config: {
             outputs: { polling_url: { name: :patient_polling_url } },
             options: { resource_type: 'Patient', bulk_export_url: 'Patient/$export' }
           }

      test from: :bulk_data_status_check,
           id: :pdex_export_patient_status_check,
           config: {
             inputs: { polling_url: { name: :patient_polling_url } },
             outputs: {
               status_response: { name: :patient_status_response },
               requires_access_token: { name: :patient_requires_access_token }
             },
             options: { resource_type: 'Patient' }
           }

      test from: :bulk_data_output_check,
           id: :pdex_export_patient_output_check,
           config: {
             inputs: { status_response: { name: :patient_status_response } },
             outputs: {
               status_output: { name: :patient_status_output },
               bulk_download_url: { name: :patient_bulk_download_url }
             },
             options: { resource_type: 'Patient' }
           }
    end
  end
end
