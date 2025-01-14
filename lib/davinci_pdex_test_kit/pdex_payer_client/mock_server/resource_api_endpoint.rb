require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      class ResourceAPIEndpoint < ProxyEndpoint

        def make_response
          super
        end
    
        def tags
          [RESOURCE_REQUEST_TAG]
        end
    
      end
    end
  end
end
