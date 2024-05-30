# frozen_string_literal: true

require 'bulk_data_test_kit/v2.0.0/bulk_data_patient_export_test_group'

require 'bulk_data_test_kit/v2.0.0/patient/bulk_data_patient_export_cancel_group'
require 'bulk_data_test_kit/v2.0.0/patient/bulk_data_patient_export_parameters_group'
require 'bulk_data_test_kit/v1.0.1/patient/bulk_data_patient_export_group'
# require 'bulk_data_test_kit/v1.0.1/patient/bulk_data_patient_export_validation_group'
require_relative 'export_validation_group'

module DaVinciTestKit
  module PDexPayerServer
    class WorkflowExportTestGroup < Inferno::TestGroup
      id :workflow_export
      title 'Server can respond to FHIR Bulk $export requests on the matched patient'
      short_title 'Bulk $export'
      optional
      description %{
        # Background

        The Patient $export operation for Payer-to-Payer exchange. See
        [PDex Implementation Guide](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#bulk-fhir-asynchronous-protocols),
        [Bulk Data Patient Export Operation](https://hl7.org/fhir/uv/bulkdata/OperationDefinition-patient-export.html), and
        [Bulk Data Export Request Flow](https://hl7.org/fhir/uv/bulkdata/export.html#bulk-data-export-operation-request-flow).

        # Methodology

        This test sequence leverages the [Bulk Data Test Kit](https://github.com/inferno-framework/bulk-data-test-kit)
        for patient-level tests conforming to the Bulk Data Access Implementation Guide v2.0.0. It removes the Patient Export
        Validation Test for multiple patients, and adds a Patient Export Scope test where the resources returned
        must be scoped to the same patient returned by `$member-match` or inputted as patient id. 
      }

      config({
        inputs: {
          url: { name: :bulk_server_url },
          # bulk_server_url: { name: :url },
          bulk_export_url: { default: 'Patient/$export' },
          bearer_token: { description: 'The authorization bearer token for $export access that is scoped to the same patient found by $member-match or entered as patient id. This is not necessarily the same OAuth token that allows access to the server\'s $member-match. If omitted $export tests will be skipped.' }
        }
      })

      input :url # inherit properties from test suite

      input :bearer_token # inherit properties from parent

      input :patient_id,
        title: 'Patient ID',
        description: 'Manual Patient ID for testing Clinical Query, $everything, and $export without $member-match.',
        optional: true

      # Required by Bulk Data tests
      fhir_client :bulk_server do
        url :url
        bearer_token :bearer_token
      end

      http_client :bulk_server do
        url :url
        headers {'Authorization' => "Bearer #{bearer_token}"}
      end

      group from: :bulk_data_patient_export_group,
            title: 'Patient Export Tests STU2',
            id: :bulk_data_patient_export_group_stu2,
            config: {
              options: { require_absolute_urls_in_output: true }
            }

      group from: :pdex_export_validation,
            title: 'Patient Export Validation Tests STU2'

      group from: :bulk_data_patient_export_cancel_group_stu2
      group from: :bulk_data_patient_export_parameters_group

      # TODO: fold this into pdex_export_validation group for SCRATCH
      group do
        title 'Patient Export Scope Tests'
        description %{
          After the asynchronous Bulk Data export operation is completed, all returned Patient
          resources must have the same ID as the Patient from `$member-match` or patient id input, 
          must be linked to the that patient id via `Patient.link.other`, must have a reference to
          any of those patients, or must have a reference to any resource thereof. There may be
          one Patient resource.
        }

        run_as_group

        test do
          title 'Server $export resources are scoped to patient resource from $member-match'

          input :patient_bulk_download_url

          run do
            omit "Unimplemented"
          end
        end
      end

    end
  end
end
