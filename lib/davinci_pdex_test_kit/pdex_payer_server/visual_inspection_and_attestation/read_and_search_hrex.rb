module DaVinciPDexTestKit
  class PDexCoverageInteractionSupportTest < Inferno::Test
    title 'Supports Read and Search for the HRex Coverage resource'

    description <<~DESCRIPTION
      The Health IT Module supports the FHIR Read and Search operations for the Coverage resource,
      using the HRex Coverage profile.
    DESCRIPTION

    id :pdex_coverage_interaction_support_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@17',
                          'hl7.fhir.us.davinci-pdex_2.0.0@18'

    run do
      identifier = SecureRandom.hex(32)

      wait(
        identifier:,
        message: <<~MESSAGE
          I attest that the Health IT Module supports both the FHIR Read and Search
          operations for the Coverage resource using the HRex Coverage profile.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** these requirements.
          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** these requirements.
        MESSAGE
      )
    end
  end
end
