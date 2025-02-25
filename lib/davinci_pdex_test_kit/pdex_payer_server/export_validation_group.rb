# require 'bulk_data_test_kit/v1.0.1/bulk_data_multiple_patients_test'
require 'bulk_data_test_kit/v1.0.1/bulk_data_ndjson_download_test'
require 'bulk_data_test_kit/v1.0.1/bulk_data_valid_resources_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class ExportValidation < Inferno::TestGroup
      title 'Patient Export Validation Tests'
      short_description 'Verify that the data from the export of all Patients conforms to the base FHIR standard.'
      description <<~DESCRIPTION
        Verify that All Patient export from the Bulk Data server follow the base FHIR standard
      DESCRIPTION

      id :pdex_export_validation

      input :patient_status_output, :patient_requires_access_token, :bearer_token, :patient_bulk_download_url
      input :lines_to_validate,
            title: 'Limit validation to a maximum resource count',
            description: 'To validate all, leave blank.',
            optional: true

      input :patient_id # from workflow_export.rb

      run_as_group

      test from: :tls_version_test do
        title 'Bulk Data Server is secured by transport layer security'
        description <<~DESCRIPTION
          [§170.315(g)(10) Test Procedure]
          (https://www.healthit.gov/test-method/standardized-api-patient-and-population-services)
          requires that all exchanges described herein between a client and a
          server SHALL be secured using Transport Layer Security  (TLS)
          Protocol Version 1.2 (RFC5246).
        DESCRIPTION
        id :pdex_bulk_file_server_tls_version

        config(
          inputs: { url: { name: :patient_bulk_download_url } },
          options: { minimum_allowed_version: OpenSSL::SSL::TLS1_2_VERSION }
        )
      end

      test from: :bulk_data_valid_resources,
           id: :pdex_bulk_data_patient_valid_resources,
           config: {
             inputs: {
               status_output: { name: :patient_status_output },
               requires_access_token: { name: :patient_requires_access_token }
             }
           }

      # NOTE: removed bulk_data_multiple_patients test, hence we need this file
    end
  end
end
