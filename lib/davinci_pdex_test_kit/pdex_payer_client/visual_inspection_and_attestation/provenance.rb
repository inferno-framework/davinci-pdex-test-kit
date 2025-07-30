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

    input :pdex_accept_retain_provenance_test_options,
          title: 'Accepts and retains Provenance in member-authorized payer-to-payer exchange',
          description: %(
            The developer of the Health IT Module attests that the system accepts and retains
                Provenance records received with data as part of a member-authorized payer-to-payer exchange.
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
    input :pdex_accept_retain_provenance_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_accept_retain_provenance_test_options == 'true', %(
        The following was not satisfied:

            The Health IT Module accepts and retains
            Provenance records received with data as part of a member-authorized payer-to-payer exchange.

      )
      pass pdex_accept_retain_provenance_test_note if pdex_accept_retain_provenance_test_note.present?
    end

    end
  end
end
