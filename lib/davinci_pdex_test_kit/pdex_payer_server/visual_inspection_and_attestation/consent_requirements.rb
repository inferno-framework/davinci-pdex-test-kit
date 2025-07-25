require_relative '../urls'

module DaVinciPDexTestKit
  class ConsentRequirementsTest < Inferno::Test
    include PDexPayerServer::URLs

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

    input :pdex_consent_requirements_test_options,
          title: 'Assesses consent requirements',
          description: %(
            The developer of the Health IT Module attests that the Health IT Module considers consent requirements to be met only if:
              - Member Identity is matched
              - Consent Policy (Everything or only Non-Sensitive data) matches the data release segmentation capabilities of the receiving payer
              - Date period for consent is valid
              - Payer requesting retrieval of data is matched.
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
    input :pdex_consent_requirements_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true



    run do
      assert pdex_consent_requirements_test_options == 'true',
             'Client application did not demonstrate correct usage of the authorization code.'
      pass pdex_consent_requirements_test_note if pdex_consent_requirements_test_note.present?
    end

  end
end
