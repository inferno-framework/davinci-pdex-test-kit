require_relative '../urls'

module DaVinciPDexTestKit
  class PDexPayerToPayerMemberMatchTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Supports mTLS for secure $member-match payer-to-payer exchange'

    description <<~DESCRIPTION
      The Health IT Module attests that the system supports secure payer-to-payer exchange for $member-match as follows:

      The **source** Health Plan is the Health Plan the member would like to get data from, and the **etarget**
      Health Plan is the Health Plan the member would like to share data to.

      1. **Secure mTLS Connection** — Establishes a mutual TLS (mTLS) connection with the target Health Plan.

      2. **Client Registration** — Supports OAuth 2.0 Dynamic Client Registration for the target Health Plan over the mTLS-secured connection.

      3. **Token Acquisition** — Accepts a Client Credentials grant request by the target Health Plan over mTLS to issue an OAuth 2.0 access
      token for the $member-match operation.

      4. **Scoped Access Token for Matched Patient** — If a Patient ID is matched, returns an OAuth 2.0 access token to the target Health Plan
      that is scoped to that member to enable further data exchange.
    DESCRIPTION

    id :pdex_payer_to_payer_mtls

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@31',
                          'hl7.fhir.us.davinci-pdex_2.0.0@32',
                          'hl7.fhir.us.davinci-pdex_2.0.0@33',
                          'hl7.fhir.us.davinci-pdex_2.0.0@34'

    input :pdex_payer_to_payer_mtls_options,
          title: 'Supports mTLS for secure $member-match payer-to-payer exchange',
          description: %(
            I attest that the Health IT Module supports secure payer-to-payer exchange for $member-match as follows:

              The **source** Health Plan is the Health Plan the member would like to get data from, and the **etarget**
              Health Plan is the Health Plan the member would like to share data to.

              1. **Secure mTLS Connection** — Establishes a mutual TLS (mTLS) connection with the target Health Plan.

              2. **Client Registration** — Supports OAuth 2.0 Dynamic Client Registration for the target Health Plan over the mTLS-secured connection.

              3. **Token Acquisition** — Accepts a Client Credentials grant request by the target Health Plan over mTLS to issue an OAuth 2.0 access
              token for the $member-match operation.

              4. **Scoped Access Token for Matched Patient** — If a Patient ID is matched, returns an OAuth 2.0 access token to the target Health Plan
              that is scoped to that member to enable further data exchange.
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
    input :pdex_payer_to_payer_mtls_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_payer_to_payer_mtls_options == 'true', %(
        The following was not satisfied:

          The Health IT Module attests that the system supports secure payer-to-payer exchange for $member-match as follows:

          The **source** Health Plan is the Health Plan the member would like to get data from, and the **etarget**
          Health Plan is the Health Plan the member would like to share data to.

          1. **Secure mTLS Connection** — Establishes a mutual TLS (mTLS) connection with the target Health Plan.

          2. **Client Registration** — Supports OAuth 2.0 Dynamic Client Registration for the target Health Plan over the mTLS-secured connection.

          3. **Token Acquisition** — Accepts a Client Credentials grant request by the target Health Plan over mTLS to issue an OAuth 2.0 access
          token for the $member-match operation.

          4. **Scoped Access Token for Matched Patient** — If a Patient ID is matched, returns an OAuth 2.0 access token to the target Health Plan
          that is scoped to that member to enable further data exchange.

      )
      pass pdex_payer_to_payer_mtls_note if pdex_payer_to_payer_mtls_note.present?
    end

  end
end
