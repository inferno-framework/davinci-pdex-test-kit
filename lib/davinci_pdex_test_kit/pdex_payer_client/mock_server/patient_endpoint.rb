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
          [RESOURCE_REQUEST_TAG, PATIENT_ID_REQUEST_TAG]
        end
    
      end
    end
  end
end
