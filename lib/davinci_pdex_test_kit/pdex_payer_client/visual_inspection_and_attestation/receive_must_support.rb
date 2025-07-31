module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexMustSupportSubElementHandlingTest < Inferno::Test
      title 'Accepts Must Support elements without error'

      description <<~DESCRIPTION
        The Health IT Module ensures that it can accept sub-elements marked Must Support
        without generating errors — unless those sub-elements belong to a parent element
        that has a minimum cardinality of 0 and no Must Support flag.
      DESCRIPTION

      id :pdex_must_support_sub_element_handling_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@53'

    input :pdex_must_support_sub_element_handling_test_options,
          title: 'Accepts Must Support elements without error',
          description: %(
            The developer of the Health IT Module attests that the Health IT System can accept sub-elements marked Must Support
                without generating errors — unless those sub-elements belong to a parent element
                that has a minimum cardinality of 0 and no Must Support flag.
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
    input :pdex_must_support_sub_element_handling_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_must_support_sub_element_handling_test_options == 'true', %(
        The following was not satisfied:

            The Health IT Module ensures that it can accept sub-elements marked Must Support
            without generating errors — unless those sub-elements belong to a parent element
            that has a minimum cardinality of 0 and no Must Support flag.

      )
      pass pdex_must_support_sub_element_handling_test_note if pdex_must_support_sub_element_handling_test_note.present?
    end

    end
  end
end
