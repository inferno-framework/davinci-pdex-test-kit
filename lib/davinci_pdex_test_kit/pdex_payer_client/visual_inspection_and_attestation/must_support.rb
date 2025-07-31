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

    input :pdex_client_must_support_interpretation_test_options,
          title: 'Interprets Must Support according to US Core and HRex',
          description: %(
            The developer of the Health IT Module attests that:

              - For US Core profiles, Must Support elements are interpreted according to the US Core IG.
              - For HRex profiles, Must Support elements are interpreted according to the HRex IG.
              - For PDex profiles, Must Support elements are interpreted according to the US Core IG.
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
    input :pdex_client_must_support_interpretation_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_client_must_support_interpretation_test_options == 'true', %(
        The following was not satisfied:

          The Health IT Module applies Must Support rules for all profiles it implements as follows:

          - For US Core profiles, Must Support elements are interpreted according to the US Core IG.
          - For HRex profiles, Must Support elements are interpreted according to the HRex IG.
          - For PDex profiles, Must Support elements are interpreted according to the US Core IG.

      )
      pass pdex_client_must_support_interpretation_test_note if pdex_client_must_support_interpretation_test_note.present?
    end

  end
end
end