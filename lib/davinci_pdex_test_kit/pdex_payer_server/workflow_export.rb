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

      group do
        title 'Patient Export was scoped to matched patient'
        description %{
            The FHIR Server SHALL constrain the data returned from the server to a requester based upon the access permissions of the requester.
            See PDex 2.0.0 Implementation Guide sections [6.2.5](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#constraining-data-based-upon-permissions-of-the-requestor)
            and [6.2.7](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#bulk-fhir-asynchronous-protocols).

            Thus the `/Patient/$export` operation should return data pertaining to one patient, despite it being a resource-level operation.
        }
        run_as_group

        test do
          title 'All patient resources have the same patient_id or links to that patient id'

          input :patient_bulk_download_url # outputed by bulk_data_patient_export_group

          run do
            skip_if !bearer_token, "No Bulk Data Access Bearer Token provided."
            skip_if !patient_id, "No Patient FHIR ID was derived from $member-match response or supplied by user input"
            skip_if !patient_bulk_download_url

            omit "Unimplemented"            
          end
        end
        
      end

    end
  end
end
