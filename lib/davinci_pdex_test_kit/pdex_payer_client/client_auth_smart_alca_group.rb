require 'smart_app_launch_test_kit'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientAuthSMARTConfidentialAsymmetricGroup < Inferno::TestGroup
      id :pdex_client_auth_smart_alca
      title 'Review Authentication Interactions'
      description %(
        During these tests, Inferno will verify that the client interacted with Inferno's
        simulated SMART authorization server in a conformant manner when requesting access tokens
        and that the client under test was able to use provided access tokens to make PDex
        requests.

        Before running these tests, perform the Data Access group so that the client
        will request an access token and use it on a data access request.
      )
      run_as_group

      # smart auth verification
      test from: :smart_client_authorization_request_verification,
          id: :pdex_client_authorization_smart_alca_verification,
          config: { options: { endpoint_suite_id: :pdex_payer_client } }
      test from: :smart_client_token_request_alca_verification,
          id: :pdex_client_token_smart_alca_verification,
          config: { options: { endpoint_suite_id: :pdex_payer_client } }
      test from: :smart_client_token_use_verification,
            config: {
              options: { access_request_tags: [RESOURCE_ID_TAG, RESOURCE_API_TAG] }
            }
    end
  end
end
