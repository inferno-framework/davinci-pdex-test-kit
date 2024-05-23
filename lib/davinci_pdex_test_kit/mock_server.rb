require_relative 'user_input_response'
require_relative 'urls'
require_relative 'collection'
require_relative 'client_validation_test.rb'


module DaVinciPDexTestKit
  # Serve responses to PAS requests
  #
  # Note that there are numerous expected validation issues that can safely be ignored.
  # See here for full list: https://hl7.org/fhir/us/davinci-pas/STU2/qa.html#suppressed
  module MockServer
    include URLs

    def server_proxy
      @server_proxy ||= Faraday.new(
          url: ENV.fetch('FHIR_REFERENCE_SERVER'),
          params: {},
          headers: {'Content-Type' => 'application/json', 'Authorization' => 'Bearer SAMPLE_TOKEN'},
        )
    end

    def token_response(request, _test = nil, _test_result = nil)
      # Placeholder for a more complete mock token endpoint
      request.response_body = { access_token: SecureRandom.hex, token_type: 'bearer', expires_in: 300 }.to_json
      request.status = 200
    end

    def claim_response(request, test = nil, test_result = nil)
      endpoint = resource_endpoint(request.url)
      params = match_request_to_expectation(endpoint, request.query_parameters)
      if params
        response = server_proxy.get(endpoint, params)
        request.status = response.status
        request.response_headers = response.headers.reject!{|key, value| key == "transfer-encoding"} # chunked causes problems for client
        request.response_body = response.body
      else
        request.status = 400
        request.response_body = "Inferno does not support a search of this query"
      end
    end

    def member_match_response(request, test = nil, test_result = nil)
      #remove token from request as well
      original_request_as_hash = JSON.parse(request.request_body).to_h
      request.request_body = original_request_as_hash.to_json
      #TODO: Change from static response
      request.response_body = {
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
      request.status = 200
    end

    def match_request_to_expectation(endpoint, params)
      matched_search = SEARCHES_BY_PRIORITY[endpoint.to_sym].find {|expectation| (params.keys.map{|key| key.to_s} & expectation) == expectation}
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
      URI.decode_www_form(request.request_body).to_h['client_id']
    end

    # Header expected to be a bearer token of the form "Bearer: <token>"
    def extract_bearer_token(request)
      request.request_header('Authorization')&.value&.split&.last
    end

    def extract_token_from_query_params(request)  
      request.query_parameters['token']
    end

    # Drop the last two segments of a URL, i.e. the resource type and ID of a FHIR resource
    # e.g. http://example.org/fhir/Patient/123 -> http://example.org/fhir
    # @private
    def base_url(url)
      return unless url.start_with?('http://', 'https://')

      # Drop everything after the second to last '/', ignoring a trailing slash
      url.sub(%r{/[^/]*/[^/]*(/)?\z}, '')
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
      valid_resource_types = [resource_type, 'OperationOutcome'].concat(additional_resource_types)
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