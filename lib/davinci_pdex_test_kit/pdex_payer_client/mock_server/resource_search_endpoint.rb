require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      # FIXME: this class is intercepting $export-poll-status requests for some reason
      # however the $export workflow still works
      class ResourceSearchEndpoint < ProxyEndpoint

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
