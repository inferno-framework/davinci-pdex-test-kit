require 'smart_app_launch_test_kit'

require_relative 'mock_server/resource_search_endpoint'
require_relative 'mock_server/resource_read_endpoint'
require_relative 'mock_server/patient_endpoint'
require_relative 'mock_server/binary_endpoint'
require_relative 'mock_server/patient_everything_endpoint'
require_relative 'mock_server/export_endpoint'
require_relative 'mock_server/export_status_endpoint'
require_relative 'mock_server/member_match_endpoint'
require_relative 'mock_server/next_page_endpoint'
require_relative 'mock_udap_smart_server/authorization_endpoint'
require_relative 'mock_udap_smart_server/token_endpoint'

require_relative '../user_input_response'
require_relative 'urls'
require_relative 'collection'
require_relative 'client_validation_test'

module DaVinciPDexTestKit
  module PDexPayerClient
    # FHIR Server for Client TestSuite
    # Requires URLs and Inferno::DSL::Runnable modules to be included in Client TestSuite
    module MockServer
      include URLs
  
      # The `suite_endpoint` function is only available in a Runnable, so
      # we define a hook where when this module is included into a class it's
      # executed in the class' namespace.
      def self.included(klass)
        klass.class_eval do

          # Add your routes/endpoints here, order matters!
          route :get, METADATA_PATH, Proc.new {
            [
              200,
              {'Content-Type' => 'application/fhir+json;charset=utf8'},
              File.readlines(File.expand_path('mock_server/resources/mock_capability_statement.json', __dir__))
            ]
          }

          # SMART App Launch / Backend Services server simulation
          route(:get, SMARTAppLaunch::SMART_DISCOVERY_PATH, lambda { |_env|
            SMARTAppLaunch::MockSMARTServer.smart_server_metadata(id)
          })
          route(:get, UDAPSecurityTestKit::UDAP_DISCOVERY_PATH, lambda { |_env|
            UDAPSecurityTestKit::MockUDAPServer.udap_server_metadata(id)
          })
          route(:get, SMARTAppLaunch::OIDC_DISCOVERY_PATH, ->(_env) {SMARTAppLaunch::MockSMARTServer.openid_connect_metadata(id) }) 
          route(
            :get,
            SMARTAppLaunch::OIDC_JWKS_PATH,
            ->(_env) { [200, { 'Content-Type' => 'application/json' }, [SMARTAppLaunch::OIDCJWKS.jwks_json]] }
          )
          suite_endpoint :post, UDAPSecurityTestKit::REGISTRATION_PATH,
                                  UDAPSecurityTestKit::MockUDAPServer::RegistrationEndpoint
          suite_endpoint :post, UDAPSecurityTestKit::TOKEN_PATH, 
                                DaVinciPDexTestKit::PDexPayerClient::MockUdapSmartServer::TokenEndpoint
          suite_endpoint :get,  UDAPSecurityTestKit::AUTHORIZATION_PATH,
                                DaVinciPDexTestKit::PDexPayerClient::MockUdapSmartServer::AuthorizationEndpoint
          suite_endpoint :post, UDAPSecurityTestKit::AUTHORIZATION_PATH,
                                DaVinciPDexTestKit::PDexPayerClient::MockUdapSmartServer::AuthorizationEndpoint

          suite_endpoint :post, MEMBER_MATCH_PATH, MemberMatchEndpoint
          suite_endpoint :get, EVERYTHING_PATH, PatientEverythingEndpoint
          suite_endpoint :get, EXPORT_PATH, ExportEndpoint
          suite_endpoint :get, EXPORT_STATUS_PATH, ExportStatusEndpoint
          suite_endpoint :get, BINARY_PATH, BinaryEndpoint
          suite_endpoint :get, PATIENT_PATH, PatientEndpoint # PDex Patient query needs its own endpoint
          suite_endpoint :get, RESOURCE_PATH, ResourceSearchEndpoint
          suite_endpoint :get, INSTANCE_PATH, ResourceReadEndpoint
          suite_endpoint :get, PATIENT_INSTANCE_PATH, ResourceReadEndpoint
          suite_endpoint :get, BASE_FHIR_PATH, NextPageEndpoint # TODO: better pagination route?

        end
      end
    end
  end
end
