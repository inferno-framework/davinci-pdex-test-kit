module DaVinciPDexTestKit
  module ClientValidationTest

    def previous_clinical_data_request_resources
      hash = Hash.new { |hash, key| hash[key] = [] }
      previous_clinical_data_requests.each_with_object(hash) do |request, request_resource_hash|
        request_resources =
          if request.status == 200
            request.resource.entry.map(&:resource)
          else
            []
          end
        request_resource_hash[request].concat(request_resources)
      end
    end

    # def collect_export_resources
    #   export_payload = collect_export_payload
    #   if export_payload
    #     ndjson_list = JSON.parse(export_payload)
    #     request_resources = ndjson_list['output'].map do |resource_binary|
    #       retrieved_resources = Faraday.new(
    #         url: resource_binary['url'],
    #         headers: {'Content-Type' => 'application/json',
    #                   'Authorization' => 'Bearer SAMPLE_TOKEN'}
    #         ).get
    #       connect_bundle(retrieved_resources.env.response_body) 
    #     end
    #     puts request_resources
    #     request_resources.flatten
    #   else
    #     nil
    #   end
    # end

    # def connect_bundle(export_binary)
    #   export_binary.split(/(?<=}\n)(?={)/).map { |str| FHIR.from_contents(str)}
    # end

    # def collect_export_payload
    #   url = export_request&.response_header('content-location')&.value
    #   attempts = 0
    #   return nil if url.nil?
    #   while attempts < 5
    #     request_attempt = Faraday.new(
    #       url: url,
    #       headers: {'Content-Type' => 'application/json',
    #                 'Authorization' => 'Bearer SAMPLE_TOKEN',
    #                 'Prefer' => 'respond-async',
    #                 'Accept' => 'application/fhir+json'}
    #       ).get
    #     if request_attempt.status != 200
    #       attempts += 1
    #       sleep(2)
    #     else
    #       return request_attempt.env.response_body
    #     end
    #   end
    #   return nil
    # end

    # def export_resources
    #   @export_resources ||= collect_export_resources 
    # end

    def previous_clinical_data_requests
      @previous_clinical_data_requests ||= load_tagged_requests(SUBMIT_TAG) + [everything_request].compact
    end

    def everything_request
      @everything_request ||= load_tagged_requests(EVERYTHING_TAG).first
    end

    def member_match_request
      @member_match_request ||= load_tagged_requests(MEMBER_MATCH_TAG).first
    end

    # def export_request
    #   @export_request ||= load_tagged_requests(EXPORT_TAG).first
    # end

    # def patient_id_from_match_request
    #   @patient_id_from_match_request ||= member_match_request ? "999" : nil #TODO: Change from static response
    # end

    def all_member_match_requests
      @all_member_match_requests ||= load_tagged_requests(MEMBER_MATCH_TAG)
    end

    def flattened_all_resources
      @flattened_all_resources ||= previous_clinical_data_request_resources.values.flatten
    end
  end
end