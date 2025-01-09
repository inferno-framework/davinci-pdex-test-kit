require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  class PDexPayerClientSuite
    module MockServer
      # Serve custom metadata from resources/
      # Although this does not proxy the request, it requires ProxyEndpoint#test_run_identifier
      class MetadataEndpoint < ProxyEndpoint
    
        def make_response
          response.body = File.read("resources/mock_capability_statement.json")
          response.headers.merge('Content-Type' => 'application/fhir+json;charset=utf8')
          response.status = 200
        end
    
        def tags
          []
        end
    
        def update_result
          # results_repo.update(result.id, result: 'pass') unless test.config.options[:accepts_multiple_requests] # TODO delete
        end
      end
    end
  end
end
