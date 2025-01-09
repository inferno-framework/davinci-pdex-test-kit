require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module MockServer
    class TokenEndpoint < ProxyEndpoint
  
      def make_response
        # TODO more complete mock token endpoint
        response.body = { access_token: SecureRandom.hex, token_type: 'bearer', expires_in: 300 }.to_json
        response.status = 200
      end
  
      def tags
        [AUTH_TAG]
      end
  
    end
  end
end
