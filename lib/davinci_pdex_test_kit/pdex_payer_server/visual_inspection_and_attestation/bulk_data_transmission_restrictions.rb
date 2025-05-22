module DaVinciPDexTestKit
  class BulkDataTransmissionRestrictionsTest < Inferno::Test
    title 'Properly restricts Bulk Data transmission of individual member data'

    description <<~DESCRIPTION
      The Health IT Module's use of the Bulk FHIR specification for transmission of individual member data honors jurisdictional and personal privacy restrictions.
    DESCRIPTION

    id :pdex_bulk_data_transmission_restrictions_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@11'

    run do
      identifier = SecureRandom.hex(32)

      wait(
        identifier:,
        message: <<~MESSAGE
          The developer of the Health IT Module attests that the Health IT Module's use of the Bulk FHIR specification for transmission of individual member data
          honors jurisdictional and personal privacy restrictions that are relevant to a member's health record.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.

          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
        MESSAGE
      )
    end
  end
end
