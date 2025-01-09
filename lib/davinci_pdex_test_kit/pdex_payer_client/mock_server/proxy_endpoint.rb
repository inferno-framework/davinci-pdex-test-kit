require 'faraday'
require 'faraday_middleware'

require_relative '../urls'

module DaVinciPDexTestKit
  class PDexPayerClientSuite
    module MockServer
      # @abstract
      # This class defines
      # - a Faraday connection for proxying requests to ENV['FHIR_REFERENCE_SERVER']
      # - common methods across PDex endpoints
      class ProxyEndpoint < Inferno::DSL::SuiteEndpoint
  
        def test_run_identifier
          request.headers['authorization']&.delete_prefix('Bearer ')
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
              url: ENV.fetch('FHIR_REFERENCE_SERVER'),
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
    
        def remove_transfer_encoding_header(headers)
          if !headers["transfer-encoding"].nil?
            headers.reject!{|key, value| key == "transfer-encoding"}
          else
            headers
          end
        end
    
        def match_request_to_expectation(endpoint, params)
          matched_search = SEARCHES_BY_PRIORITY[endpoint.to_sym].find {|expectation| (params.keys.map{|key| key.to_s} & expectation).sort == expectation}
          # matched_search_without_patient = SEARCHES_BY_PRIORITY[endpoint.to_sym].find {|expectation| (params.keys.map{|key| key.to_s} << "patient" & expectation) == expectation}
    
          if matched_search
            params.select {|key, value| matched_search.include?(key.to_s) || key == "_revInclude" || key == "_include"}
          else
            nil
          end
          # else
          #   new_params = params.select {|key, value| matched_search_without_patient.include?(key.to_s) || key == "_revInclude" || key == "_include"}
          #   new_params["patient"] = patient_id_from_match_request
          #   new_params
          # end
        end
    
        def extract_client_id(request)
          URI.decode_www_form(request.body.read).to_h['client_id']
        end
    
        # TODO delete
        # def extract_bearer_token(request)
        #   request.headers['authorization']&.delete_prefix('Bearer ')
        # end
    
        def extract_token_from_query_params(request)
          request.query_parameters['token']
        end
    
        # Pull resource type from url
        # e.g. http://example.org/fhir/Patient/123 -> Patient
        # @private
        def resource_endpoint(url)
          return unless url.start_with?('http://', 'https://')
    
          /custom\/pdex_payer_client\/fhir\/(.*)\?/.match(url)[1]
        end
    
        # @private
        def referenced_entities(resource, entries, root_url)
          matches = []
          attributes = resource&.source_hash&.keys
          attributes.each do |attr|
            value = resource.send(attr.to_sym)
            if value.is_a?(FHIR::Reference) && value.reference.present?
              match = find_matching_entry(value.reference, entries, root_url)
              if match.present? && matches.none?(match)
                value.reference = match.fullUrl
                matches.concat([match], referenced_entities(match.resource, entries, root_url))
              end
            elsif value.is_a?(Array) && value.all? { |elmt| elmt.is_a?(FHIR::Model) }
              value.each { |val| matches.concat(referenced_entities(val, entries, root_url)) }
            end
          end
    
          matches
        end
    
        def mock_operation_outcome_resource
          FHIR.from_contents(File.read("lib/davinci_pdex_test_kit/metadata/mock_operation_outcome_resource.json"))
        end
    
        def replace_bundle_urls(bundle)
          reference_server_base = ENV.fetch('FHIR_REFERENCE_SERVER')
          bundle&.link.map! {|link| {relation: link.relation, url: link.url.gsub(reference_server_base, URLs.base_fhir_url)}}
          bundle&.entry&.map! do |bundled_resource| 
            {
             fullUrl: bundled_resource.fullUrl.gsub(reference_server_base, URLs.base_fhir_url),
             resource: bundled_resource.resource,
             search: bundled_resource.search
            }
          end
          bundle
        end
    
        def replace_export_urls(export_status_output)
          reference_server_base = ENV.fetch('FHIR_REFERENCE_SERVER')
          export_status_output['output'].map! { |binary| {type: binary["type"], url: binary["url"].gsub(reference_server_base, URLs.base_fhir_url)} }
          export_status_output['request'] = URLs.base_fhir_url + '/Patient/$export'
          export_status_output
        end
    
        # @private
        def absolute_reference(ref, entries, root_url)
          url = find_matching_entry(ref&.reference, entries, root_url)&.fullUrl
          ref.reference = url if url
          ref
        end
    
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
    
        # @private
        def find_matching_entry(ref, entries, root_url = '')
          ref = "#{root_url}/#{ref}" if relative_reference?(ref) && root_url&.present?
    
          entries&.find { |entry| entry&.fullUrl == ref }
        end
    
        # @private
        def relative_reference?(ref)
          ref&.count('/') == 1
        end  
      end
    end
  end
end
