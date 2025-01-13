require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      class ResourceAPIEndpoint < ProxyEndpoint
    
        def make_response
          resource_response(request, test, result)
        end
    
        def tags
          [RESOURCE_REQUEST_TAG]
        end
    
        private
  
        # TODO: xform into proxy response in abstract class
        def resource_response(request, _test = nil, _test_result = nil)
          endpoint = resource_endpoint(request.url)
          param_hash = {}
          request.params.each { |name, value| param_hash[name] = value }
          params = match_request_to_expectation(endpoint, param_hash)
          if params
            server_response = server_proxy.get(endpoint, params)
            response_resource_json = replace_bundle_urls(FHIR.from_contents(server_response.body)).to_json
            response.format = 'application/fhir+json'
            response.body = response_resource_json
            response.status = server_response.status
          else
            server_response = server_proxy.get('Patient', {_id: 999})
            response_resource = FHIR.from_contents(server_response.body)
            response_resource.entry = [{fullUrl: 'urn:uuid:2866af9c-137d-4458-a8a9-eeeec0ce5583', resource: mock_operation_outcome_resource, search: {mode: 'outcome'}}]
            response_resource.link.first.url = request.url #specific case for Operation Outcome handling
            response.status = 400
            response.body = response_resource.to_json
            response.format = 'application/fhir+json'
          end
        end
    
      end
    end
  end
end
