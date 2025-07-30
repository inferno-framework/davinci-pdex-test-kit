require_relative '../urls'

module DaVinciPDexTestKit
  class BulkDataTransmissionRestrictionsTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Properly restricts Bulk Data transmission of individual member data'

    description <<~DESCRIPTION
      The Health IT Module's use of the Bulk FHIR specification for transmission of individual member data honors jurisdictional and personal privacy restrictions.
    DESCRIPTION

    id :pdex_bulk_data_transmission_restrictions_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@11'

    input :pdex_bulk_data_transmission_restrictions_test_options,
          title: 'Properly restricts Bulk Data transmission of individual member data',
          description: %(
            The developer of the Health IT Module attests that the Health IT Module's use of the Bulk FHIR specification for transmission of individual member data
              honors jurisdictional and personal privacy restrictions that are relevant to a member's health record.
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
    input :pdex_bulk_data_transmission_restrictions_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_bulk_data_transmission_restrictions_test_options == 'true', %(
        The following was not satisfied:

          The Health IT Module's use of the Bulk FHIR specification for transmission of individual member data honors jurisdictional and personal privacy restrictions.

      )
      pass pdex_bulk_data_transmission_restrictions_test_note if pdex_bulk_data_transmission_restrictions_test_note.present?
    end

  end
end
