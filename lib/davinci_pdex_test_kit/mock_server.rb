require 'faraday'
require 'faraday_middleware'

require_relative 'mock_server/metadata_endpoint'
require_relative 'mock_server/token_endpoint'
require_relative 'mock_server/resource_api_endpoint'
require_relative 'mock_server/binary_endpoint'
require_relative 'mock_server/patient_everything_endpoint'
require_relative 'mock_server/export_endpoint'
require_relative 'mock_server/export_status_endpoint'
require_relative 'mock_server/member_match_endpoint'
require_relative 'mock_server/next_page_endpoint'

require_relative 'user_input_response'
require_relative 'urls'
require_relative 'pdex_payer_client/collection'
require_relative 'pdex_payer_client/client_validation_test'

# TODO factor all of this into client suite
module DaVinciPDexTestKit
  # Serve responses to PDex requests by proxying to Inferno Reference Server
  # Must be imported into a class with `Inferno::DSL::Runnable`
  module MockServer
    include URLs

    # This callback gets triggered on `include MockServer`, which then mounts the endpoints
    # This is necessary because `suite_endpoint` is only available from `Inferno::DSL::Runnable`
    # but not here
    def self.included(klass)
      klass.extend SuiteExtension
    end

    class SuiteExtension
      extend Inferno::DSL::Runnable

      suite_endpoint :get, METADATA_PATH, MetadataEndpoint
      suite_endpoint :post, TOKEN_PATH, TokenEndpoint
      suite_endpoint :get, PATIENT_PATH, ResourceAPIEndpoint
      suite_endpoint :get, RESOURCE_PATH, ResourceAPIEndpoint
      suite_endpoint :get, BINARY_PATH, BinaryEndpoint
      suite_endpoint :get, EVERYTHING_PATH, PatientEverythingEndpoint
      suite_endpoint :get, EXPORT_PATH, ExportEndpoint
      suite_endpoint :get, EXPORT_STATUS_PATH, ExportStatusEndpoint
      suite_endpoint :post, MEMBER_MATCH_PATH, MemberMatchEndpoint
      suite_endpoint :get, BASE_FHIR_PATH, NextPageEndpoint # TODO: better pagination implementation?
    end
  end
end
