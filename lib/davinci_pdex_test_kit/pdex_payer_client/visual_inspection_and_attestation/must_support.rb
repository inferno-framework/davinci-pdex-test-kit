module DaVinciPDexTestKit
  module PDexPayerClient
  class PDexClientMustSupportInterpretationTest < Inferno::Test
    title 'Interprets Must Support according to US Core and HRex'

    description <<~DESCRIPTION
      The Health IT Module applies Must Support rules for all profiles it implements as follows:

      - For US Core profiles, Must Support elements are interpreted according to the US Core IG.
      - For HRex profiles, Must Support elements are interpreted according to the HRex IG.
      - For PDex profiles, Must Support elements are interpreted according to the US Core IG.
    DESCRIPTION

    id :pdex_client_must_support_interpretation_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@4',
                          'hl7.fhir.us.davinci-pdex_2.0.0@6',
                          'hl7.fhir.us.davinci-pdex_2.0.0@8'

    run do
      identifier = SecureRandom.hex(32)

      wait(
        identifier:,
        message: <<~MESSAGE
          The developer of the Health IT Module attests that:

          - For US Core profiles, Must Support elements are interpreted according to the US Core IG.
          - For HRex profiles, Must Support elements are interpreted according to the HRex IG.
          - For PDex profiles, Must Support elements are interpreted according to the US Core IG.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** these requirements.
          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** these requirements.
        MESSAGE
      )
    end
  end
end
end