module DaVinciPDexTestKit
  class PDexProvenanceTest < Inferno::Test
    title 'Includes and generates provenance records as required'

    description <<~DESCRIPTION
      The Health IT Module
      - Incorporates provenance records received as part of any FHIR data exchange.
      - Generates provenance records for each non-Provenance resource, at a minimum identifying the
        Health Plan as the Transmitter of the data in PDex exchanges.
    DESCRIPTION

    id :pdex_provenance_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@12',
                          'hl7.fhir.us.davinci-pdex_2.0.0@13'

    run do
      identifier = SecureRandom.hex(32)

      wait(
        identifier:,
        message: <<~MESSAGE
          The developer of the Health IT Module attests that the system:

          - Incorporates provenance records received as part of any FHIR data exchange.
          - Generates provenance records for each non-Provenance resource, at a minimum identifying the
            Health Plan as the Transmitter of the data in PDex exchanges.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** these requirements.

          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** these requirements.
        MESSAGE
      )
    end
  end
end
