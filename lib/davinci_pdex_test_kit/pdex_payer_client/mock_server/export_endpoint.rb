require_relative '../tags'
require_relative '../urls'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      class ExportEndpoint < ProxyEndpoint

        include ::DaVinciPDexTestKit::PDexPayerClient::URLs
    
        def make_response
          http_headers_as_hash = request.env.select { |k,v| k.start_with? 'HTTP_'}.transform_keys { |k| k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-') }
          server_response = server_proxy.get do |req|
            req.url 'Group/pdex-Group/$export' # TODO: change from static response
            req.headers = http_headers_as_hash.merge(server_proxy.headers)
          end
          response.headers["content-location"] = server_response.headers["content-location"]&.gsub(/(.*)\?/, "#{base_fhir_url}/$export-poll-status?")
          response.body = server_response.body
        end
    
        def tags
          [EXPORT_TAG]
        end
    
      end
    end
  end
end
