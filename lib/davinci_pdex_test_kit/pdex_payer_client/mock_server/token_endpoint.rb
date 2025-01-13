require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      # Although token enpoint is not actually proxying, inherit from ProxyEndpoint to keep
      # #test_run_identifier and #update_result
      class TokenEndpoint < ProxyEndpoint
    
        def make_response
          response.status = 200
          response.body = { access_token: SecureRandom.hex, token_type: 'bearer', expires_in: 300 }.to_json
          response.format = :json
        end
    
        def tags
          [AUTH_TAG]
        end
    
      end
    end
  end
end
