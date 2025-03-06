module DaVinciPDexTestKit
  module PDexPayerServer
    # Factorized test for asserting a patient resource opeartion in a Capability Statement
    #
    # ==== Inputs
    #
    # (none)
    #
    # ==== Outputs
    #
    # (none)
    #
    # ==== Required Config
    #
    # options:
    #   operation_name: operation to check for, i.e: 'member-match'
    #   operation_url: operation definition canonical URL
    #
    # ==== Required Scratch
    #
    # (none)
    #
    # ==== Notes
    #
    # Requires an Inferno fhir client configured.
    #
    class PatientOperationInCapabilityStatementValidation < Inferno::Test
      id :pdex_patient_operation_in_cap_stmt_validation

      description %{
        The [CapabilityStatement](https://hl7.org/fhir/R4/capabilitystatement.html) must declare support for the
        patient resource-level operation in `CapabilityStatement.rest[].resource(type: Patient).operation` by
        having both name (without `$`) and definition (canonical URL). See the operation definition for these
        values.

        The operation shall only be declared in one object in the `rest` array.
      }

      verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@30'

      run do
        fhir_get_capability_statement

        assert_response_status(200)
        assert_resource_type(:capability_statement)

        assert(
          resource.rest&.one? do |rest_metadata|
            rest_metadata.resource&.find { |resource_metadata| resource_metadata.type == 'Patient' }
              &.operation&.any? do |operation_metadata|
                operation_metadata.name == config.options[:operation_name] &&
                operation_metadata.definition == config.options[:operation_url]
              end
          end
        )
      end
    end
  end
end
