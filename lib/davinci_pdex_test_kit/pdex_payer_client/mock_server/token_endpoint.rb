require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      # This endpoint is intended to help clients jumpstart the payer-to-payer workflow
      # but Inferno requires a bearer token to recieve this endpoint anyways so
      # this doesn't offer much utility.
      # TODO: open this endpoint, or send auth to another service
      class TokenEndpoint < ProxyEndpoint
    
        def make_response
          response.status = 200
          # TODO: derive access_token from suite inputs
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
