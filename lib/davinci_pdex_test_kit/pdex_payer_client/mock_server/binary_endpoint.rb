require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      class BinaryEndpoint < ProxyEndpoint
    
        def make_response
          binary_id = request.url.split('/').last
          server_response = server_proxy.get('Binary/'+binary_id) do |request|
            request.headers['Accept'] = 'application/fhir+ndjson'
          end
          response.format = 'application/fhir+ndjson'
          response.body = server_response.body
          response.status = server_response.status
        end
    
        def tags
          [BINARY_TAG]
        end
    
      end
    end
  end
end
