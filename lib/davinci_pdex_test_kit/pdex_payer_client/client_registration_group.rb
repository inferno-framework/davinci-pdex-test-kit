require 'udap_security_test_kit'
require 'smart_app_launch_test_kit'
require_relative 'pdex_client_options'
require_relative 'client_registration/configuration_display_smart_test'
require_relative 'client_registration/configuration_display_udap_test'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientRegistrationGroup < Inferno::TestGroup
      id :pdex_client_registration
      title 'Client Registration'
      description %(
        Register the client under test with Inferno's simulated PDex Server,
        including configuration of the system under test to hit the correct endpoints and
        enable authentication and authorization of PDex requests.
      )
      run_as_group

      # smart registration tests
      test from: :smart_client_registration_alca_verification,
            required_suite_options: {
              client_type: PDexClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
            }
      test from: :smart_client_registration_alcs_verification,
            required_suite_options: {
              client_type: PDexClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
            }
      test from: :smart_client_registration_alp_verification,
            required_suite_options: {
              client_type: PDexClientOptions::SMART_APP_LAUNCH_PUBLIC
            }
      test from: :pdex_client_reg_config_smart_display,
            id: :pdex_client_reg_config_smart_alca_display,
            required_suite_options: {
              client_type: PDexClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
            }
      test from: :pdex_client_reg_config_smart_display,
            id: :pdex_client_reg_config_smart_alcs_display,
            required_suite_options: {
              client_type: PDexClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
            }
      test from: :pdex_client_reg_config_smart_display,
            id: :pdex_client_reg_config_smart_alp_display,
            required_suite_options: {
              client_type: PDexClientOptions::SMART_APP_LAUNCH_PUBLIC
            }

      # udap registration tests
      test from: :udap_client_registration_interaction,
          id: :pdex_client_reg_udap_interaction,
          config: { options: { endpoint_suite_id: :pdex_payer_client } },
          required_suite_options: {
            client_type: PDexClientOptions::UDAP_AUTHORIZATION_CODE
          }
      test from: :udap_client_registration_ac_verification,
          id: :pdex_client_reg_udap_verification,
          config: { options: { endpoint_suite_id: :pdex_payer_client } },
          required_suite_options: {
            client_type: PDexClientOptions::UDAP_AUTHORIZATION_CODE
          }
      test from: :pdex_client_reg_config_udap_display,
            required_suite_options: {
              client_type: PDexClientOptions::UDAP_AUTHORIZATION_CODE
            }
    end
  end
end
