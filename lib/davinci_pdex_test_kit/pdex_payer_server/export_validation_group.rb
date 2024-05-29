# export_validation_group.rb

# frozen_string_literal: true

# require 'bulk_data_test_kit/v1.0.1/bulk_data_multiple_patients_test'
require 'bulk_data_test_kit/v1.0.1/bulk_data_ndjson_download_test'
require 'bulk_data_test_kit/v1.0.1/bulk_data_valid_resources_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class BulkDataPatientExportValidation < Inferno::TestGroup
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

      test from: :tls_version_test do
        title 'Bulk Data Server is secured by transport layer security'
        description <<~DESCRIPTION
          [§170.315(g)(10) Test Procedure]
          (https://www.healthit.gov/test-method/standardized-api-patient-and-population-services)
          requires that all exchanges described herein between a client and a
          server SHALL be secured using Transport Layer Security  (TLS)
          Protocol Version 1.2 (RFC5246).
        DESCRIPTION
        id :bulk_file_server_tls_version

        config(
          inputs: { url: { name: :patient_bulk_download_url } },
          options: { minimum_allowed_version: OpenSSL::SSL::TLS1_2_VERSION }
        )
      end

      test from: :bulk_data_ndjson_download,
           id: :bulk_data_patient_ndjson_download,
           config: {
             inputs: {
               bulk_download_url: { name: :patient_bulk_download_url },
               requires_access_token: { name: :patient_requires_access_token }
             }
           }

      test from: :bulk_data_valid_resources,
           id: :bulk_data_patient_valid_resources,
           config: {
             inputs: {
               status_output: { name: :patient_status_output },
               requires_access_token: { name: :patient_requires_access_token }
             }
           }

      # test from: :bulk_data_multiple_patients,
      #      id: :bulk_data_patient_multiple_patients

      test do
        title 'Bulk Data is scoped to Patient from $member-match'
        description %{

        }

        run do
          omit "Unimplemented"
          # TODO this
          # https://github.com/inferno-framework/bulk-data-test-kit/blob/main/lib/bulk_data_test_kit/bulk_export_validation_tester.rb#L129
        end
      end
    end
  end
end
