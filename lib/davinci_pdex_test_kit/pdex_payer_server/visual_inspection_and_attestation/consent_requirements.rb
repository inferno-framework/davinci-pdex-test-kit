module DaVinciPDexTestKit
  class ConsentRequirementsTest < Inferno::Test
    title 'Assesses consent requirements'

    description <<~DESCRIPTION
      The Health IT Module considers consent requirements to be met only if:
      - Member Identity is matched
      - Consent Policy (Everything or only Non-Sensitive data) matches the data release segmentation capabilities of the receiving payer
      - Date period for consent is valid
      - Payer requesting retrieval of data is matched.
    DESCRIPTION

    id :pdex_consent_requirements_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@40'

    run do
      identifier = SecureRandom.hex(32)

      wait(
        identifier:,
        message: <<~MESSAGE
          The developer of the Health IT Module attests that the Health IT Module considers consent requirements to be met only if:
          - Member Identity is matched
          - Consent Policy (Everything or only Non-Sensitive data) matches the data release segmentation capabilities of the receiving payer
          - Date period for consent is valid
          - Payer requesting retrieval of data is matched.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.

          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
        MESSAGE
      )
    end
  end
end
