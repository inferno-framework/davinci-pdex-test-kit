# frozen_string_literal: true

require 'bulk_data_test_kit/v2.0.0/bulk_data_patient_export_test_group'

module DaVinciTestKit
  module PDexPayerServer
    class WorkflowExportTestGroup < BulkDataTestKit::BulkDataV200::BulkDataPatientTestGroup
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
        and attempt patient-level tests from Bulk Data Access Implementation Guide v2.0.0.
      }

      # Recycled from Bulk Data test suite
      input :bulk_server_url,
            title: 'Bulk Data FHIR URL',
            description: 'The URL of the Bulk FHIR server.'

      fhir_client :bulk_server do
        url :bulk_server_url
      end

      http_client :bulk_server do
        url :bulk_server_url
      end

    end
  end
end
