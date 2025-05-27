require_relative '../urls'

module DaVinciPDexTestKit
  class PDexMemberAuthorizedExchangeTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Supports Payer-to-Payer member-authorized exchange'

    description <<~DESCRIPTION
      The Health IT Module supports Payer-to-Payer member-authorized
      information exchange using SMART on FHIR and OAuth 2.0 by satisfying the following criteria.

      The Health IT Module is acting as the **source** Health Plan, and is the Health Plan the member would like to get data from.
      The **target** Health Plan is the Health PLan the member would like to share data to.

      1. **Client Authorization Credentials**
          The Health IT Module issues the target Health Plan OAuth 2.0 client application credentials during client registration.

      1. **Member Consent Flow**
          After the member authenticates to the Health IT Module's authorization server, the system presents an Authorization
          screen enabling the member to approve sharing with the target Health Plan.

          The Authorization process aligns with applicable privacy policy and regulations, allowing members to
          select what data may be shared.

      4. **Token Issuance**
          Upon successful authorization, the Health IT Module issues an Access Token to the target Health Plan.
          The scopes associated with the Access Token are limited to the information and permissions authorized by the member.

      6. **Refresh Token Handling**:
          Any Access Token subsequently issued by the Health IT Module using a Refresh Token enforces the same scope and member-specific
          restrictions as the original authorization.
    DESCRIPTION

    id :pdex_member_authorized_exchange_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@20',
                          'hl7.fhir.us.davinci-pdex_2.0.0@21',
                          'hl7.fhir.us.davinci-pdex_2.0.0@22',
                          'hl7.fhir.us.davinci-pdex_2.0.0@23',
                          'hl7.fhir.us.davinci-pdex_2.0.0@25',
                          'hl7.fhir.us.davinci-pdex_2.0.0@26'

    run do
      identifier = SecureRandom.hex(32)

      wait(
        identifier:,
        message: <<~MESSAGE
          I attest that the Health IT Module supports Payer-to-Payer member-authorized
          information exchange using SMART on FHIR and OAuth 2.0 by satisfying the following criteria.

          The **source** Health Plan is the Health Plan the member would like to get data from, and the **etarget**
          Health Plan is the Health PLan the member would like to share data to.

          1. **Client Authorization Credentials**
              The Health IT Module issues the target Health Plan OAuth 2.0 client application credentials during client registration.

          1. **Member Consent Flow**
              After the member authenticates to the Health IT Module's authorization server, the system presents an Authorization
              screen enabling the member to approve sharing with the target Health Plan.

              The Authorization process aligns with applicable privacy policy and regulations, allowing members to
              select what data may be shared.

          4. **Token Issuance**
              Upon successful authorization, the Health IT Module issues an Access Token to the target Health Plan.
              The scopes associated with the Access Token are limited to the information and permissions authorized by the member.

          6. **Refresh Token Handling**:
              Any Access Token subsequently issued by the Health IT Module using a Refresh Token enforces the same scope and member-specific
              restrictions as the original authorization.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** these requirements.

          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** these requirements.
        MESSAGE
      )
    end
  end
end
