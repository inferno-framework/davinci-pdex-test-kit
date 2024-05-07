module DaVinciPDexTestKit
  module ClientValidationTest

    def previous_request_resources
      hash = Hash.new { |hash, key| hash[key] = [] }
      previous_requests.each_with_object(hash) do |request, request_resource_hash|
        request_resources =
          if request.status == 200
            request.resource.entry.map(&:resource)
          else
            []
          end
        request_resource_hash[request].concat(request_resources)
      end
    end

    def previous_requests
      @previous_requests ||= load_tagged_requests(SUBMIT_TAG)
    end

    def flattened_all_resources
      @flattened_all_resources ||= previous_request_resources.values.flatten
    end
  end
end