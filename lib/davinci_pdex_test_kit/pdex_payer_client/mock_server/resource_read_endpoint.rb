require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      class ResourceReadEndpoint < ProxyEndpoint

        def proxy_request(request)
          target_resource = request.url.split('/')[-2..-1].join('/')
          server_proxy.get(target_resource)
        end
    
        def tags
          [RESOURCE_ID_TAG]
        end
    
      end
    end
  end
end
