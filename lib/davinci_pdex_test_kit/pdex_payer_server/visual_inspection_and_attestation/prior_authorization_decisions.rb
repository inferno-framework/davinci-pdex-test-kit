module DaVinciPDexTestKit
  class PriorAuthorizationDecisionsTest < Inferno::Test
    title 'Makes available pending and active prior authorization decisions'

    description <<~DESCRIPTION
      The Health IT Module makes available pending and active prior authorization decisions and related clinical documentation and forms for items and services.
    DESCRIPTION

    id :pdex_prior_authorization_decisions_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@56'

    run do
      identifier = SecureRandom.hex(32)

      wait(
        identifier:,
        message: <<~MESSAGE
          The developer of the Health IT Module attests that the Health IT Module makes available pending and active prior authorization decisions
          and related clinical documentation and forms for items and services, not including prescription drugs, including the date the prior authorization was approved,
          the date the authorization ends, as well as the units and services approved and those used to date, no later than one (1) business day after a provider initiates
          a prior authorization for the beneficiary or there is a change of status for the prior authorization.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.

          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
        MESSAGE
      )
    end
  end
end
