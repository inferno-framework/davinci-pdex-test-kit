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

    run do
      identifier = SecureRandom.hex(32)

      wait(
        identifier:,
        message: <<~MESSAGE
          The developer of the Health IT Module attests that all FHIR resources and operations
          available via a FHIR API endpoint are declared in the system's CapabilityStatement.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** these requirements.

          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** these requirements.
        MESSAGE
      )
    end
  end
end
