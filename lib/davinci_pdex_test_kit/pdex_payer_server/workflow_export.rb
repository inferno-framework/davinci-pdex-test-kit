# frozen_string_literal: true

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

        This test sequence is still in development. Early adopters should look at the
        [Bulk Data Test Kit](https://github.com/inferno-framework/bulk-data-test-kit)
        and attempt patient-level tests.
      }

      test do
        id :workflow_export_in_capability_statement
        title 'Server asserts Patient instance operation $export in Capability Statement'

        run do
          fhir_get_capability_statement

          assert_response_status 200
          assert(
            resource.rest.one? do |rest_metadata|
              rest_metadata.resource.select { |resource_metadata| resource_metadata.type == 'Patient' }.first
                .operation.any? do |operation_metadata|
                  operation_metadata.name == 'export' && operation_metadata.definition == 'http://hl7.org/fhir/uv/bulkdata/OperationDefinition/patient-export'
                end
            end
          )
        end
      end

      # TODO: implement for Bulk Import tests OR import them
      # test do
      #   id :workflow_export_patient
      #   title ''
      #
      #   input :patient_id
      # 
      #   run do
      #     skip_if !patient_id
      #       "No member identifier from $member-match or Patient ID from input was supplied"
      #
      #     omit "Unimplemented"
      #   end
      # end

    end
  end
end
