require_relative '../urls'

module DaVinciPDexTestKit
  class PriorAuthorizationDecisionsTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Makes available pending and active prior authorization decisions'

    description <<~DESCRIPTION
      The Health IT Module makes available pending and active prior authorization decisions and related clinical documentation and forms for items and services.
    DESCRIPTION

    id :pdex_prior_authorization_decisions_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@56'

    input :pdex_prior_authorization_decisions_test_options,
          title: 'Makes available pending and active prior authorization decisions',
          description: %(
            The developer of the Health IT Module attests that the Health IT Module makes available pending and active prior authorization decisions
              and related clinical documentation and forms for items and services, not including prescription drugs, including the date the prior authorization was approved,
              the date the authorization ends, as well as the units and services approved and those used to date, no later than one (1) business day after a provider initiates
              a prior authorization for the beneficiary or there is a change of status for the prior authorization.
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
    input :pdex_prior_authorization_decisions_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_prior_authorization_decisions_test_options == 'true', %(
        The following was not satisfied:

          The Health IT Module makes available pending and active prior authorization decisions and related clinical documentation and forms for items and services.

      )
      pass pdex_prior_authorization_decisions_test_note if pdex_prior_authorization_decisions_test_note.present?
    end

  end
end
