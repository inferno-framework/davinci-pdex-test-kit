require_relative '../urls'

module DaVinciPDexTestKit
  class PDexMemberMatchConsentFailureHandlingTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Handles consent non-compliance correctly during $member-match'

    description <<~DESCRIPTION
      The Health IT Module correctly handles situations where during the `$member-match` operation:
          - If a unique match to a member is found but the consent request cannot be honored (e.g., due to unsupported data segmentation policies), the system does not return a Patient ID in the response.
          - In such cases, the system returns an HTTP 422 status code with an accompanying Operation Outcome that explains why the consent request could not be honored.

    DESCRIPTION

    id :pdex_member_match_consent_failure_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@38',
                          'hl7.fhir.us.davinci-pdex_2.0.0@39'

    run do
      identifier = SecureRandom.hex(32)

      wait(
        identifier:,
        message: <<~MESSAGE
          The developer of the Health IT Module attests that during the `$member-match` operation:

          - If a unique match to a member is found but the consent request cannot be honored (e.g., due to unsupported data segmentation policies), the system does not return a Patient ID in the response.

          - In such cases, the system returns an HTTP 422 status code with an accompanying Operation Outcome that explains why the consent request could not be honored.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** these requirements.
          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** these requirements.
        MESSAGE
      )
    end
  end
end
