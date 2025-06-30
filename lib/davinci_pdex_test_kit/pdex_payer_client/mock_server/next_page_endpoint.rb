require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      class NextPageEndpoint < ProxyEndpoint
    
        def make_response
          server_response = server_proxy.get('', JSON.parse(request.params.to_json))
          response.status = server_response.status
          fhir_response = FHIR.from_contents(server_response.body)
          return unless fhir_response.present?

          response.format = 'application/fhir+json'
          if fhir_response.is_a?(FHIR::Bundle)
            response.body = replace_bundle_urls(fhir_response).to_json
          else
            response.body = fhir_response.to_json
          end
        end
    
        def tags
          [RESOURCE_API_TAG]
        end
    
      end
    end
  end
end
