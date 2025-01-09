require_relative '../tags'
require_relative 'proxy_endpoint'

module DaVinciPDexTestKit
  module MockServer
    class ExportStatusEndpoint < ProxyEndpoint
  
      def make_response
        http_headers_as_hash = request.env.select { |k,v| k.start_with? 'HTTP_'}.transform_keys { |k| k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-') }
        server_response = server_proxy.get do |req|
          req.url '$export-poll-status'
          req.params = request.params
          req.headers = http_headers_as_hash.merge(server_proxy.headers)
        end
        response.body = server_response.status.to_i == 200 ? replace_export_urls(JSON.parse(server_response.body)).to_json : server_response.body
      end
  
      def tags
        [EXPORT_STATUS_TAG]
      end
  
    end
  end
end
