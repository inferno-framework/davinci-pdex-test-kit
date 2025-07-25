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

    input :pdex_member_match_consent_failure_test_options,
          title: 'Handles consent non-compliance correctly during $member-match',
          description: %(
            The developer of the Health IT Module attests that during the `$member-match` operation:

              - If a unique match to a member is found but the consent request cannot be honored (e.g., due to unsupported data segmentation policies), the system does not return a Patient ID in the response.

              - In such cases, the system returns an HTTP 422 status code with an accompanying Operation Outcome that explains why the consent request could not be honored.
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
    input :pdex_member_match_consent_failure_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true



    run do
      assert pdex_member_match_consent_failure_test_options == 'true',
             'Client application did not demonstrate correct usage of the authorization code.'
      pass pdex_member_match_consent_failure_test_note if pdex_member_match_consent_failure_test_note.present?
    end

  end
end
