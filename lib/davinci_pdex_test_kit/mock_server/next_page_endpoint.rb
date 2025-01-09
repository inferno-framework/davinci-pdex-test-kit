require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module MockServer
    class NextPageEndpoint < ProxyEndpoint
  
      def make_response
        server_response = server_proxy.get('', JSON.parse(request.params.to_json))
        response.status = server_response.status
        response.format = 'application/fhir+json'
        response.body = replace_bundle_urls(FHIR.from_contents(server_response.body)).to_json
      end
  
      def tags
        [RESOURCE_REQUEST_TAG]
      end
  
    end
  end
end
