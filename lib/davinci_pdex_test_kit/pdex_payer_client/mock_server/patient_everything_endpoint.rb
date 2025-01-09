require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  class PDexPayerClientSuite
    module MockServer
      class PatientEverythingEndpoint < ProxyEndpoint
    
        def make_response
          server_response = server_proxy.get('Patient/999/$everything') # TODO: Change from static request
    
          response.format = 'application/fhir+json'
          response.body = replace_bundle_urls(FHIR.from_contents(server_response.body)).to_json
          response.status = server_response.status
        end
    
        def tags
          [EVERYTHING_TAG]
        end
    
      end
    end
  end
end
