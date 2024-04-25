module DaVinciPDexTestKit
  module ClientValidationTest


    def previous_request_resources
      first_request = previous_requests.first
      next_page_url = nil
      hash = Hash.new { |hash, key| hash[key] = [] }
      previous_requests.each_with_object(hash) do |request, request_resource_hash|
        request_resources =
          if request.status == 200
            request.resource.entry.map(&:resource)
          else
            []
          end

        first_request = request if request.url != next_page_url

        request_resource_hash[first_request].concat(request_resources)

        next if request.resource&.resourceType != 'Bundle'

        next_page_url = request.resource&.link&.find { |link| link.relation == 'next' }&.url
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