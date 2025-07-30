require_relative '../urls'

module DaVinciPDexTestKit
  class PayerConsentComplianceTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Constrains response based on access permissions'

    description <<~DESCRIPTION
      The Health IT Module constrains the data returned from the server to a requester based upon the access permissions of the requester.
    DESCRIPTION

    id :pdex_payer_consent_compliance_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@45'

    input :pdex_payer_consent_compliance_test_options,
          title: 'Constrains response based on access permissions',
          description: %(
            The developer of the Health IT Module attests that the Health IT Module constrains the data returned from the server to a requester
              based upon the access permissions of the requester.
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
    input :pdex_payer_consent_compliance_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_payer_consent_compliance_test_options == 'true', %(
        The following was not satisfied:

          The Health IT Module constrains the data returned from the server to a requester based upon the access permissions of the requester.

      )
      pass pdex_payer_consent_compliance_test_note if pdex_payer_consent_compliance_test_note.present?
    end

  end
end
