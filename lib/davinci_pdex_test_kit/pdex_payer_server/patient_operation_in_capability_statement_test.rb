# frozen_string_literal: true

module DaVinciPDexTestKit
  module PDexPayerServer
    class PatientOperationInCapabilityStatementTest < Inferno::Test
      id :patient_operation_in_capability_statement_test

      description %{
        The [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) must declare support for the
        patient resource-level operation in `CapabilityStatement.rest[].resource(type: Patient).operation` by
        having both name (without `$`) and definition (canonical URL). See the operation definition for these
        values.

        The operation shall only be declared in one object in the `rest` array.
      }

      run do
          fhir_get_capability_statement

          assert_response_status(200)
          assert_resource_type(:capability_statement)

          assert(
            resource.rest.one? do |rest_metadata|
              rest_metadata.resource.select { |resource_metadata| resource_metadata.type == 'Patient' }.first
                .operation.any? do |operation_metadata|
                  operation_metadata.name == config.options[:operation_name] &&
                  operation_metadata.definition == config.options[:operation_url]
                end
            end
          )
      end
    end
  end
end
