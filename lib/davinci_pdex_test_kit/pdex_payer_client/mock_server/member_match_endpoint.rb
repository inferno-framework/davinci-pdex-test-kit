require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      # Although this enpoint is not actually proxying, inherit from ProxyEndpoint to keep
      # #test_run_identifier and #update_result
      class MemberMatchEndpoint < ProxyEndpoint    
        def make_response
          #remove token from request as well
          original_request_as_hash = JSON.parse(request.body.string).to_h
          request.body.string = original_request_as_hash.to_json
  
          #TODO: Change from static response
          response.body = {
            resourceType: "Parameters",
            parameter: [
              {
                name: "MemberIdentifier",
                valueIdentifier: {
                  type: {
                    coding: [
                      {
                        system: "http://terminology.hl7.org/CodeSystem/v2-0203",
                        code: "MB"
                      }
                    ]
                  },
                  system: "https://github.com/inferno-framework/target-payer/identifiers/member",
                  value: "99999",
                  assigner: {
                    display: "Old Payer"
                  }
                }
              }
            ]
          }.to_json
  
          response.status = 200
          response.format = 'application/fhir+json'
        end
    
        def tags
          [MEMBER_MATCH_TAG]
        end
    
      end
    end
  end
end
