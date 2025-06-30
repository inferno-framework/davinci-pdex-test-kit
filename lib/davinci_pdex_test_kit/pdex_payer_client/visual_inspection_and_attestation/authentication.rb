module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexMemberAuthenticationTest < Inferno::Test
      title 'Uses recognized Health Plan credentials'

      description <<~DESCRIPTION
        The Health IT Module requires members to authenticate
        using credentials issued or recognized by the Health Plan, such as credentials used to access
        a member portal, and accepts only those credentials when processing member-authorized requests.
      DESCRIPTION

      id :pdex_member_authentication_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@10'

      run do
        identifier = SecureRandom.hex(32)

        wait(
          identifier:,
          message: <<~MESSAGE
            I attest that the Health IT Module requires members to authenticate
            using credentials issued or recognized by the Health Plan, such as credentials used to access
            a member portal, and accepts only those credentials when processing member-authorized requests.

            [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.

            [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
          MESSAGE
        )
      end
    end
  end
end