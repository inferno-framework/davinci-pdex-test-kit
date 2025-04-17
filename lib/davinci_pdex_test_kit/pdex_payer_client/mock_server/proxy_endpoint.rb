require 'faraday'
require 'faraday_middleware'

require_relative '../urls'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      # @abstract
      # This class defines
      # - a Faraday connection for proxying requests to ENV['FHIR_REFERENCE_SERVER']
      # - common methods and conventions for PDex Client Testing endpoints
      class ProxyEndpoint < Inferno::DSL::SuiteEndpoint

        include ::DaVinciPDexTestKit::PDexPayerClient::URLs
  
        def test_run_identifier
          request.headers['authorization']&.delete_prefix('Bearer ')
        end
  
        def make_response
          server_response = proxy_request(request)
          proxy_response(server_response)
        end

        def update_result
          results_repo.update(result.id, result: 'pass') unless test.config.options[:accepts_multiple_requests]
        end
    
        # REST Client that proxies request to server at `ENV[FHIR_REFERENCE_SERVER]`
        # @return [Faraday] - A Faraday 1.x REST Client
        # @example
        #   server_response = server_proxy.get('Patient/1')
        #   server_response.body # => FHIR JSON String
        def server_proxy
          @server_proxy ||= Faraday.new(
              url: fhir_reference_server,
              params: {},
              headers: {
                'Accept' => 'application/fhir+json,application/json',
                'Accept-Encoding' => 'identity',
                'Authorization' => 'Bearer SAMPLE_TOKEN',
                'Host' => ENV.fetch('HOST_HEADER')
              }
            ) do |proxy|
              proxy.use Faraday::Response::Logger
            end
        end

        protected

        def fhir_reference_server
          ENV.fetch('FHIR_REFERENCE_SERVER')
        end

        # Modify and send request to server proxy. Intended for use in {#make_response}.
        # @param request [Hanami::Action::Request]
        # @option strict [Boolean] if true will return 400 for any requests not allowed by PDex API.
        #   The implementation of 'strict' is based on {#match_request_to_expectation} and collections.rb
        # @return [Faraday::Response]
        def proxy_request(request, strict: true)
          fhir_endpoint = resource_endpoint(request.url)

          server_params = request.params.to_hash
          server_params = match_request_to_expectation(fhir_endpoint, server_params) unless request.url.include?('$') # exclude operations as hotfix

          if strict && server_params.empty?
            Faraday::Response.new(
              status: 400,
              response_body: File.read(File.expand_path('resources/mock_operation_outcome_resource.json', __dir__))
            )
          else
            server_proxy.get(fhir_endpoint, server_params)
          end
        end

        # Pull resource type from url
        # @return [String | nil]
        # @example
        #   resource_endpoint('http://localhost:4567/custom/pdex_payer_client/fhir/Patient/1') # => 'Patient'
        def resource_endpoint(url)
          return unless url.start_with?('http://', 'https://')
    
          /custom\/pdex_payer_client\/fhir\/([a-zA-Z_-]+)([\/\?].*)?/.match(url)&.to_a&.at(1)
        end

        def supported_searches
          @supported_searchs ||= SEARCHES_BY_PRIORITY
        end

        # Filter request parameters to only include those allowed by PDex API (hardcoded in collections.rb)
        # @return [Hash]
        def match_request_to_expectation(endpoint, params)
          matched_search = supported_searches[endpoint.to_sym]&.find {|expectation| (params.keys.map{|key| key.to_s} & expectation).sort == expectation}
    
          if matched_search
            params.select {|key, value| matched_search.include?(key.to_s) || key == "_revInclude" || key == "_include"}
          else
            {}
          end
        end

        # Modify response to pretend that mock server generated it. Optionally pass a block to make more modifications.
        # @param server_response [Faraday::Response]
        # @yield [FHIR::Model] If response is FHIR yield the resource for modifications
        # @yieldreturn [FHIR::Model]
        # @return [Hanami::Action::Response] Inferno mock server response
        # @example
        #   def make_response
        #     response = proxy_response(response, Faraday.get('https://example.com/fhir/Patient/1')) do |patient|
        #       patient.meta.profile << "http://example.com/fhir/my-ig-profile"
        #     end
        #   end
        def proxy_response(server_response, &block)
          response.status = server_response.status

          if server_response.headers.present?
            headers = remove_transfer_encoding_header(server_response.headers) 
            response.headers.merge!(headers)
          end
          response.headers.merge!({'Server' => self.class.name.deconstantize})

          if is_fhir?(server_response.body)
            response.format = 'application/fhir+json'
            resource = FHIR.from_contents(server_response.body)
            resource = replace_bundle_urls(resource) if resource.resourceType == 'Bundle'

            resource = yield(resource) if block_given?

            response.body = resource.to_json

          elsif is_json?(server_response.body)
            response.format = 'application/json'
            # Uncomment to recklessly replace all proxy urls with our urls:
            # response.body = server_response.body.gsub(fhir_reference_server, base_fhir_url)
            response.body = server_response.body

          else
            # Uncomment to recklessly replace all proxy urls with our urls:
            # response.body = server_response.body.gsub(fhir_reference_server, base_fhir_url)
            response.body = server_response.body
          end

          response
        end

        def remove_transfer_encoding_header(headers)
          if !headers["transfer-encoding"].nil?
            headers.reject!{|key, value| key == "transfer-encoding"}
          else
            headers
          end
        end

        def is_fhir?(str)
          !!FHIR.from_contents(str)
        rescue StandardError
          false
        end

        def replace_bundle_urls(bundle)
          bundle&.link.map! {|link| {relation: link.relation, url: link.url.gsub(fhir_reference_server, base_fhir_url)}}
          bundle&.entry&.map! do |bundled_resource| 
            {
             fullUrl: bundled_resource.fullUrl.gsub(fhir_reference_server, base_fhir_url),
             resource: bundled_resource.resource,
             search: bundled_resource.search
            }
          end
          bundle
        end

        def is_json?(str)
          !!JSON.parse(str)
        rescue StandardError
          false
        end

      end
    end
  end
end
