module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexRetainProvenanceFromPayerExchangeTest < Inferno::Test
      title 'Accepts and retains Provenance in member-authorized payer-to-payer exchange'

      description <<~DESCRIPTION
        The Health IT Module accepts and retains
        Provenance records received with data as part of a member-authorized payer-to-payer exchange.
      DESCRIPTION

      id :pdex_accept_retain_provenance_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@28'

      run do
        identifier = SecureRandom.hex(32)

        wait(
          identifier:,
          message: <<~MESSAGE
            I attest that the Health IT Module accepts and retains
            Provenance records received with data as part of a member-authorized payer-to-payer exchange.

            [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.

            [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
          MESSAGE
        )
      end
    end
  end
end
