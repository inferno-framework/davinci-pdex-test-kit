require_relative '../urls'

module DaVinciPDexTestKit
  class PDexProvenanceTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Includes and generates provenance records as required'

    description <<~DESCRIPTION
      The Health IT Module
      - Incorporates provenance records received as part of any FHIR data exchange.
      - Generates provenance records for each non-Provenance resource, at a minimum identifying the
        Health Plan as the Transmitter of the data in PDex exchanges.
    DESCRIPTION

    id :pdex_provenance_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@12',
                          'hl7.fhir.us.davinci-pdex_2.0.0@13'

    input :pdex_provenance_test_options,
          title: 'Includes and generates provenance records as required',
          description: %(
            The developer of the Health IT Module attests that the system:

              - Incorporates provenance records received as part of any FHIR data exchange.
              - Generates provenance records for each non-Provenance resource, at a minimum identifying the
                Health Plan as the Transmitter of the data in PDex exchanges.
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
    input :pdex_provenance_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_provenance_test_options == 'true', %(
        The following was not satisfied:

          The Health IT Module
          - Incorporates provenance records received as part of any FHIR data exchange.
          - Generates provenance records for each non-Provenance resource, at a minimum identifying the
            Health Plan as the Transmitter of the data in PDex exchanges.

      )
      pass pdex_provenance_test_note if pdex_provenance_test_note.present?
    end

  end
end
