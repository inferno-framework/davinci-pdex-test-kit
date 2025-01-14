require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      class PatientEverythingEndpoint < ProxyEndpoint
    
        def make_response
          # server_response = proxy_request(request, strict: false) # disable strict to allow $everything request without parameters
          # response = proxy_response(server_response)
          patient_id = request.url.match(/Patient\/([A-Za-z0-9\-\.]{1,64})\/\$everything/)&.to_a&.at(1)

          if patient_id.nil?
            response.status = 400
            response.body = "Invalid patient id for Patient $everything request: #{request.url}"
            response.format = :text
          else
            server_response = server_proxy.get("Patient/#{patient_id}/$everything")
          
            response.status = server_response.status
            response.body = replace_bundle_urls(FHIR.from_contents(server_response.body)).to_json
            response.format = 'application/fhir+json'
          end
        end
    
        def tags
          [EVERYTHING_TAG]
        end
    
      end
    end
  end
end
