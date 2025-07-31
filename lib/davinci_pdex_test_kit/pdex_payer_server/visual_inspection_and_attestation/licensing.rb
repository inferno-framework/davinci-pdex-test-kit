require_relative '../urls'

module DaVinciPDexTestKit
  class PDexLicensingTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Complies with licensing requirements'

    description <<~DESCRIPTION
      The Health IT Module abides by the license
      requirements for each terminology content artifact utilized within a functioning implementation and obtained
      terminology licenses from the Third-Party IP owner for each code system and/or other specified artifact used.
    DESCRIPTION

    id :pdex_licensing_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@1',
                          'hl7.fhir.us.davinci-pdex_2.0.0@2'

    input :pdex_licensing_test_options,
          title: 'Complies with licensing requirements',
          description: %(
            The developer of the Health IT Module attests that the Health IT Module abides by the license
              requirements for each terminology content artifact utilized within a functioning implementation and obtained
              terminology licenses from the Third-Party IP owner for each code system and/or other specified artifact used.
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
    input :pdex_licensing_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_licensing_test_options == 'true', %(
        The following was not satisfied:

          The Health IT Module abides by the license
          requirements for each terminology content artifact utilized within a functioning implementation and obtained
          terminology licenses from the Third-Party IP owner for each code system and/or other specified artifact used.

      )
      pass pdex_licensing_test_note if pdex_licensing_test_note.present?
    end

  end
end
