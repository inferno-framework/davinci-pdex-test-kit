require 'faraday'
require 'faraday_middleware'

require_relative '../urls'

module DaVinciPDexTestKit
  module PDexPayerClient
    module MockServer
      # @abstract
      # This class defines
      # - a Faraday connection for proxying requests to ENV['FHIR_REFERENCE_SERVER']
      # - common methods across PDex endpoints
      class ProxyEndpoint < Inferno::DSL::SuiteEndpoint

        include ::DaVinciPDexTestKit::PDexPayerClient::URLs
  
        def test_run_identifier
          request.headers['authorization']&.delete_prefix('Bearer ')
        end
  
        def make_response
          server_response = proxy_request(request)
          response = proxy_response(server_response)
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
        # @return [Faraday::Response]
        def proxy_request(request)
          fhir_endpoint = resource_endpoint(request.url)

          server_params = request.params.to_hash
          server_params = match_request_to_expectation(fhir_endpoint, server_params)

          server_proxy.get(fhir_endpoint, server_params) # .tap {|response| pp "DEBUG: response: #{response}" }
          # if params
            # server_response = server_proxy.get(fhir_endpoint, server_params)
            # response.body = replace_bundle_urls(FHIR.from_contents(server_response.body)).to_json
            # response.status = server_response.status

          # TODO fix or remove
          # else
          #   server_response = server_proxy.get('Patient', {_id: 999})
          #   response_resource = FHIR.from_contents(server_response.body)
          #   response_resource.entry = [{fullUrl: 'urn:uuid:2866af9c-137d-4458-a8a9-eeeec0ce5583', resource: mock_operation_outcome_resource, search: {mode: 'outcome'}}]
          #   response_resource.link.first.url = request.url # specific case for Operation Outcome handling
          #   response.status = 400
          #   response.body = response_resource.to_json
          # end
        end

        # Pull resource type from url
        # @return [String | nil]
        # @example
        #   resource_endpoint('http://localhost:4567/custom/pdex_payer_client/fhir/Patient/1') # => 'Patient'
        def resource_endpoint(url)
          return unless url.start_with?('http://', 'https://')
    
          /custom\/pdex_payer_client\/fhir\/([a-zA-Z_-]+)([\/\?].*)?/.match(url)&.to_a&.at(1)
        end

        # Filter request parameters to only include those allowed by PDex API (hardcoded in collections.rb)
        # This allows a non-strict client requests
        # @return [Hash]
        def match_request_to_expectation(endpoint, params)
          matched_search = SEARCHES_BY_PRIORITY[endpoint.to_sym].find {|expectation| (params.keys.map{|key| key.to_s} & expectation).sort == expectation}
    
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

          headers = remove_transfer_encoding_header(server_response.headers)
          response.headers.merge!(headers)
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

        # TODO fix/test or remove
        def mock_operation_outcome_resource
          FHIR.from_contents(File.read(File.expand_path('resources/mock_operation_outcome_resource.json', __dir__)))
        end
        
        # TODO delete
        # def extract_client_id(request)
        #   URI.decode_www_form(request.body.read).to_h['client_id']
        # end
    
        # TODO delete
        # def extract_bearer_token(request)
        #   request.headers['authorization']&.delete_prefix('Bearer ')
        # end
        
        # TODO: fix/test and incorporate this into replace_bundle_urls
        # def referenced_entities(resource, entries, root_url)
        #   matches = []
        #   attributes = resource&.source_hash&.keys
        #   attributes.each do |attr|
        #     value = resource.send(attr.to_sym)
        #     if value.is_a?(FHIR::Reference) && value.reference.present?
        #       match = find_matching_entry(value.reference, entries, root_url)
        #       if match.present? && matches.none?(match)
        #         value.reference = match.fullUrl
        #         matches.concat([match], referenced_entities(match.resource, entries, root_url))
        #       end
        #     elsif value.is_a?(Array) && value.all? { |elmt| elmt.is_a?(FHIR::Model) }
        #       value.each { |val| matches.concat(referenced_entities(val, entries, root_url)) }
        #     end
        #   end    
        #   matches
        # end

        # @private
        # def absolute_reference(ref, entries, root_url)
        #   url = find_matching_entry(ref&.reference, entries, root_url)&.fullUrl
        #   ref.reference = url if url
        #   ref
        # end

        # @private
        # def find_matching_entry(ref, entries, root_url = '')
        #   ref = "#{root_url}/#{ref}" if relative_reference?(ref) && root_url&.present?
    
        #   entries&.find { |entry| entry&.fullUrl == ref }
        # end
    
        # @private
        # def relative_reference?(ref)
        #   ref&.count('/') == 1
        # end  

        # TODO: fix/test this if we want to handle pagination at the proxy    
        # def fetch_all_bundled_resources(
        #       # reply_handler: nil,
        #       # max_pages: 0,
        #       # additional_resource_types: [],
        #       # resource_type: self.resource_type
        #     )
        #   page_count = 1
        #   resources = []
        #   bundle = resource
        #   resources += bundle&.entry&.map { |entry| entry&.resource }
    
        #   until bundle.nil? || (page_count == max_pages && max_pages != 0)
        #     
        #     next_bundle_link = bundle&.link&.find { |link| link.relation == 'next' }&.url
        #     reply_handler&.call(response)
    
        #     break if next_bundle_link.blank?
    
        #     reply = fhir_client.raw_read_url(next_bundle_link)
    
        #     store_request('outgoing') { reply }
        #     error_message = cant_resolve_next_bundle_message(next_bundle_link)
    
        #     assert_response_status(200)
        #     assert_valid_json(reply.body, error_message)
    
        #     bundle = fhir_client.parse_reply(FHIR::Bundle, fhir_client.default_format, reply)
        #     resources += bundle&.entry&.map { |entry| entry&.resource }
    
        #     page_count += 1
        #   end
        #   # valid_resource_types = [resource_type, 'OperationOutcome'].concat(additional_resource_types) # XXX
        #   resources
        # end

      end
    end
  end
end
