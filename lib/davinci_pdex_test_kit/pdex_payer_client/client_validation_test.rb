module DaVinciPDexTestKit
  class PDexPayerClientSuite
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
  
      def connect_bundle(export_binary)
        export_binary.split(/(?<=}\n)(?={)/).map { |str| FHIR.from_contents(str)}
      end
  
      def export_resources
        @export_resources ||= (load_tagged_requests(BINARY_TAG).map { |binary_read| binary_read.response_body.split("\n") }.flatten).map { |resource_in_binary| FHIR.from_contents(resource_in_binary)}
      end
  
      def previous_clinical_data_requests
        @previous_clinical_data_requests ||= load_tagged_requests(RESOURCE_REQUEST_TAG) + [everything_request].compact
      end
  
      def everything_request
        @everything_request ||= load_tagged_requests(EVERYTHING_TAG).first
      end
  
      def member_match_request
        @member_match_request ||= load_tagged_requests(MEMBER_MATCH_TAG).first
      end
  
      def export_request
        @export_request ||= load_tagged_requests(EXPORT_TAG).first
      end
  
      def export_status_request
        @export_status_request ||= load_tagged_requests(EXPORT_STATUS_TAG).first
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
end
