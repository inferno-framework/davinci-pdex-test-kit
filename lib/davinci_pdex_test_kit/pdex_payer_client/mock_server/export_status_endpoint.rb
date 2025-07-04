require_relative '../tags'
require_relative '../urls'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      class ExportStatusEndpoint < ProxyEndpoint

        include ::DaVinciPDexTestKit::PDexPayerClient::URLs
    
        def make_response
          http_headers_as_hash = request.env.select { |k,v| k.start_with? 'HTTP_'}.transform_keys { |k| k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-') }

          server_response = server_proxy.get do |req|
            req.url '$export-poll-status'
            req.params = request.params
            req.headers = http_headers_as_hash.merge(server_proxy.headers)
          end
 
          if server_response.status.to_s.starts_with?('4') || server_response.status.to_s.starts_with?('5')
            response.format = 'application/fhir+json'
          elsif server_response.status.to_i == 202
            response.format = 'application/json'
          end

          response.body = (server_response.status.to_i == 200) ? replace_export_urls(JSON.parse(server_response.body)).to_json : server_response.body
          response.status = server_response.status
        end
    
        def tags
          [EXPORT_STATUS_TAG]
        end

        def replace_export_urls(export_status_output)
          export_status_output['output'].map! { |binary| {type: binary["type"], url: binary["url"].gsub(fhir_reference_server, fhir_base_url)} }
          export_status_output['request'] = export_url
          export_status_output
        end
    
      end
    end
  end
end
