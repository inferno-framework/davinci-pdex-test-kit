require_relative '../urls'

module DaVinciPDexTestKit
  class PDexMustSupportDefinedByHRexTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Uses HRex Must Support definitions for HRex profiles'

    description <<~DESCRIPTION
      The Health IT Module applies the definition of "Must Support" as defined
      by the Da Vinci HRex Implementation Guide for all HRex profiles referenced in PDex.
    DESCRIPTION

    id :pdex_must_support_defined_by_hrex_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@5'

    input :pdex_must_support_defined_by_hrex_test_options,
          title: 'Uses HRex Must Support definitions for HRex profiles',
          description: %(
            The developer of the Health IT Module attests that the system applies the definition
              of "Must Support" as defined by the Da Vinci HRex Implementation Guide for all
              HRex profiles referenced in PDex.
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
    input :pdex_must_support_defined_by_hrex_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true



    run do
      assert pdex_must_support_defined_by_hrex_test_options == 'true',
             'Client application did not demonstrate correct usage of the authorization code.'
      pass pdex_must_support_defined_by_hrex_test_note if pdex_must_support_defined_by_hrex_test_note.present?
    end

  end
end
