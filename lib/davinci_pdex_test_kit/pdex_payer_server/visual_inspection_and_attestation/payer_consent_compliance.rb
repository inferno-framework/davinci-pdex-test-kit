module DaVinciPDexTestKit
  class PayerConsentComplianceTest < Inferno::Test
    title 'Constrains response based on access permissions'

    description <<~DESCRIPTION
      The Health IT Module constrains the data returned from the server to a requester based upon the access permissions of the requester.
    DESCRIPTION

    id :pdex_payer_consent_compliance_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@45'

    run do
      identifier = SecureRandom.hex(32)

      wait(
        identifier:,
        message: <<~MESSAGE
          The developer of the Health IT Module attests that the Health IT Module constrains the data returned from the server to a requester
          based upon the access permissions of the requester.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.

          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
        MESSAGE
      )
    end
  end
end
