require 'udap_security_test_kit'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientAuthUDAPGroup < Inferno::TestGroup
      id :pdex_client_auth_udap
      title 'Review UDAP Authentication Interactions'
      description %(
        During these tests, Inferno will verify that the client interacted with Inferno's
        simulated UDAP authorization server in a conformant manner when requesting access tokens
        and that the client under test was able to use provided access tokens to make PDex
        requests.

        Before running these tests, perform the Data Access group so that the client
        will request an access token and use it on a data access request.
      )
      run_as_group

      test from: :udap_client_authorization_request_verification,
          id: :pdex_client_authorization_udap_verification,
          config: { options: { endpoint_suite_id: :pdex_payer_client } }
      test from: :udap_client_token_request_ac_verification,
          id: :pdex_client_token_udap_verification,
          config: { options: { endpoint_suite_id: :pdex_payer_client } }
      test from: :udap_client_token_use_verification,
            config: {
              options: { access_request_tags: [RESOURCE_ID_TAG, RESOURCE_API_TAG] }
            }
    end
  end
end
