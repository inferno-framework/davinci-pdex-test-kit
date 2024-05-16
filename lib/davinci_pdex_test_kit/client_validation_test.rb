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

    def previous_clinical_data_requests
      @previous_clinical_data_requests ||= load_tagged_requests(SUBMIT_TAG)
    end

    def member_match_request
      @member_match_request ||= load_tagged_requests(MEMBER_MATCH_TAG).first
    end

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