require_relative '../urls'

module DaVinciPDexTestKit
  class PDexCoverageInteractionSupportTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Supports Read and Search for the HRex Coverage resource'

    description <<~DESCRIPTION
      The Health IT Module supports the FHIR Read and Search operations for the Coverage resource,
      using the HRex Coverage profile.
    DESCRIPTION

    id :pdex_coverage_interaction_support_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@17',
                          'hl7.fhir.us.davinci-pdex_2.0.0@18'

    input :pdex_coverage_interaction_support_test_options,
          title: 'Supports Read and Search for the HRex Coverage resource',
          description: %(
            The developer of the Health IT Module attests that the system supports both the FHIR Read and Search
              operations for the Coverage resource using the HRex Coverage profile.
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
    input :pdex_coverage_interaction_support_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_coverage_interaction_support_test_options == 'true', %(
        The following was not satisfied:

          The Health IT Module supports the FHIR Read and Search operations for the Coverage resource,
          using the HRex Coverage profile.

      )
      pass pdex_coverage_interaction_support_test_note if pdex_coverage_interaction_support_test_note.present?
    end

  end
end
