require_relative '../tags'
require_relative '../urls'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      class PatientEndpoint < ProxyEndpoint
        include ::DaVinciPDexTestKit::PDexPayerClient::URLs

        def make_response
          super
        end

        def tags
          tags = [RESOURCE_ID_TAG]
          tags << PATIENT_ID_REQUEST_TAG if request.url.include?('99999')
          
          tags
        end
    
      end
    end
  end
end
