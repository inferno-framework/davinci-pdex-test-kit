require_relative 'user_input_response'
require_relative 'urls'
require_relative 'pdex_payer_client/collection'
require_relative 'pdex_payer_client/client_validation_test'
require 'faraday'
require 'faraday_middleware'

module DaVinciPDexTestKit
  # Serve responses to PDex requests by proxying to Inferno Reference Server
  module MockServer
    include URLs

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

    def token_response(request, _test = nil, _test_result = nil)
      # Placeholder for a more complete mock token endpoint
      response.body = { access_token: SecureRandom.hex, token_type: 'bearer', expires_in: 300 }.to_json
      response.status = 200
    end

    def resource_response(request, _test = nil, _test_result = nil)
      endpoint = resource_endpoint(request.url)
      param_hash = {}
      request.params.each { |name, value| param_hash[name] = value }
      params = match_request_to_expectation(endpoint, param_hash)
      if params
        server_response = server_proxy.get(endpoint, params)
        response_resource_json = replace_bundle_urls(FHIR.from_contents(server_response.body)).to_json
        response.format = 'application/fhir+json'
        response.body = response_resource_json
        response.status = server_response.status
      else
        server_response = server_proxy.get('Patient', {_id: 999})
        response_resource = FHIR.from_contents(server_response.body)
        response_resource.entry = [{fullUrl: 'urn:uuid:2866af9c-137d-4458-a8a9-eeeec0ce5583', resource: mock_operation_outcome_resource, search: {mode: 'outcome'}}]
        response_resource.link.first.url = request.url #specific case for Operation Outcome handling
        response.status = 400
        response.body = response_resource.to_json
        response.format = 'application/fhir+json'
      end
    end

    def read_next_page(request, test = nil, test_result = nil)
      server_response = server_proxy.get('', JSON.parse(request.params.to_json))
      response.status = server_response.status
      response.format = 'application/fhir+json'
      response.body = replace_bundle_urls(FHIR.from_contents(server_response.body)).to_json
    end

    def everything_response(request, test = nil, test_result = nil)
      server_response = server_proxy.get('Patient/999/$everything') # TODO: Change from static request

      response.format = 'application/fhir+json'
      response.body = replace_bundle_urls(FHIR.from_contents(server_response.body)).to_json
      response.status = server_response.status
    end

    def export_response(request, test = nil, test_result = nil)
      http_headers_as_hash = request.env.select { |k,v| k.start_with? 'HTTP_'}.transform_keys { |k| k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-') }
      server_response = server_proxy.get do |req|
        req.url 'Group/pdex-Group/$export' # TODO: change from static response
        req.headers = http_headers_as_hash.merge(server_proxy.headers)
      end
      response.headers["content-location"] = server_response.headers["content-location"]&.gsub(/(.*)\?/, "#{new_link}/$export-poll-status?")
      response.body = server_response.body
    end

    def export_status_response(request, test = nil, test_result = nil)
      http_headers_as_hash = request.env.select { |k,v| k.start_with? 'HTTP_'}.transform_keys { |k| k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-') }
      server_response = server_proxy.get do |req|
        req.url '$export-poll-status'
        req.params = request.params
        req.headers = http_headers_as_hash.merge(server_proxy.headers)
      end
      response.body = server_response.status.to_i == 200 ? replace_export_urls(JSON.parse(server_response.body)).to_json : server_response.body
    end

    def binary_read_response(request, _test = nil, _test_result = nil)
      binary_id = request.url.split('/').last
      server_response = server_proxy.get('Binary/'+binary_id)
      response.format = 'application/fhir+ndjson'
      response.body = server_response.body
      response.status = server_response.status
    end

    def member_match_response(request, test = nil, test_result = nil)
      # remove token from request as well
      original_request_as_hash = JSON.parse(request.body.string).to_h
      request.body.string = original_request_as_hash.to_json
      # TODO: Change from static response
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

    def get_metadata
      proc { [200, {'Content-Type' => 'application/fhir+json;charset=utf-8'}, [File.read("lib/davinci_pdex_test_kit/metadata/mock_capability_statement.json")]] }
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

    # Header expected to be a bearer token of the form "Bearer: <token>"
    def extract_bearer_token(request)
      request.headers['authorization']&.delete_prefix('Bearer ')
    end

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
      bundle&.link.map! {|link| {relation: link.relation, url: link.url.gsub(reference_server_base, new_link)}}
      bundle&.entry&.map! do |bundled_resource| 
        {
         fullUrl: bundled_resource.fullUrl.gsub(reference_server_base, new_link),
         resource: bundled_resource.resource,
         search: bundled_resource.search
        }
      end
      bundle
    end

    def replace_export_urls(export_status_output)
      reference_server_base = ENV.fetch('FHIR_REFERENCE_SERVER')
      export_status_output['output'].map! { |binary| {type: binary["type"], url: binary["url"].gsub(reference_server_base, new_link)} }
      export_status_output['request'] = new_link + '/Patient/$export'
      export_status_output
    end

    def new_link
      "#{Inferno::Application['base_url']}\/custom\/pdex_payer_client\/fhir"
    end

    # @private
    def absolute_reference(ref, entries, root_url)
      url = find_matching_entry(ref&.reference, entries, root_url)&.fullUrl
      ref.reference = url if url
      ref
    end

    def fetch_all_bundled_resources(
          reply_handler: nil,
          max_pages: 0,
          additional_resource_types: [],
          resource_type: self.resource_type
        )
      page_count = 1
      resources = []
      bundle = resource
      resources += bundle&.entry&.map { |entry| entry&.resource }

      until bundle.nil? || (page_count == max_pages && max_pages != 0)
        
        next_bundle_link = bundle&.link&.find { |link| link.relation == 'next' }&.url
        reply_handler&.call(response)

        break if next_bundle_link.blank?

        reply = fhir_client.raw_read_url(next_bundle_link)

        store_request('outgoing') { reply }
        error_message = cant_resolve_next_bundle_message(next_bundle_link)

        assert_response_status(200)
        assert_valid_json(reply.body, error_message)

        bundle = fhir_client.parse_reply(FHIR::Bundle, fhir_client.default_format, reply)
        resources += bundle&.entry&.map { |entry| entry&.resource }

        page_count += 1
      end
      # valid_resource_types = [resource_type, 'OperationOutcome'].concat(additional_resource_types)
      resources
    end

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
