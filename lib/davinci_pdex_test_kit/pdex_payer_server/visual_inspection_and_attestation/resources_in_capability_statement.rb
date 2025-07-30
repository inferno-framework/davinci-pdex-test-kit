require_relative '../urls'

module DaVinciPDexTestKit
  class PDexCapabilityStatementDeclarationTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Declares resources and operations in CapabilityStatement'

    description <<~DESCRIPTION
      The Health IT Module declares all FHIR resources and operations available via its API
      in its FHIR CapabilityStatement, in accordance with PDex requirements.
    DESCRIPTION

    id :pdex_capability_statement_declaration_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@15',
                          'hl7.fhir.us.davinci-pdex_2.0.0@19'

    input :pdex_capability_statement_declaration_test_options,
          title: 'Declares resources and operations in CapabilityStatement',
          description: %(
            The developer of the Health IT Module attests that all FHIR resources and operations
              available via a FHIR API endpoint are declared in the system's CapabilityStatement.
          ),
          type: 'radio',
          default: 'false',
          options: {
            list_options: [
              {
                label: 'Yes',
                value: 'true'
              },
              {
                label: 'No',
                value: 'false'
              }
            ]
          }
    input :pdex_capability_statement_declaration_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_capability_statement_declaration_test_options == 'true', %(
        The following was not satisfied:

          The Health IT Module declares all FHIR resources and operations available via its API
          in its FHIR CapabilityStatement, in accordance with PDex requirements.

      )
      pass pdex_capability_statement_declaration_test_note if pdex_capability_statement_declaration_test_note.present?
    end

  end
end
