require 'bulk_data_test_kit/v2.0.0/bulk_data_patient_export_test_group'
require_relative 'export_patient_group'
require_relative 'export_validation_group'

module DaVinciTestKit
  module PDexPayerServer
    class WorkflowExportGroup < Inferno::TestGroup
      id :pdex_workflow_export
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
        for patient-level tests conforming to the Bulk Data Access Implementation Guide v2.0.0, and does not require more than 1 patient
        to be returned by Patient-level export. The tests require a Bulk Data Autthorization Bearer Token.
      }

      config({
               inputs: {
                 url: { name: :bulk_server_url },
                 bulk_export_url: { default: 'Patient/$export' },
                 bearer_token: { description: 'The authorization bearer token for $export access that is scoped to the same patient found by $member-match or entered as patient id. This is not necessarily the same OAuth token that allows access to the server\'s $member-match. If omitted $export tests will be skipped.' }
               }
             })

      input :url # inherit properties from test suite

      input :bearer_token

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
        headers { 'Authorization' => "Bearer #{bearer_token}" }
      end

      group from: :pdex_patient_export

      group from: :pdex_export_validation,
            title: 'Patient Export Validation Tests',
            optional: true
    end
  end
end
