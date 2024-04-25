require_relative 'client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexInitialRequestLoggingTest < Inferno::Test
    include DaVinciPDexTestKit::ClientValidationTest
    include URLs

    id :initial_request_logging
    title 'Placeholder for showing the requests received and the responses given to each.'
    description %(
      
    )
    input :access_token

    run do
      info flattened_all_resources.to_json
      expected_resources = SET_TO_BE_GATHERED.values.flatten
      resource_ids = flattened_all_resources.map(&:id)

      collected_resources, missed_resources = expected_resources.partition do |expected_resource|
        resource_ids.include?(expected_resource)
      end

      assert missed_resources.empty?, "Unable to find the following expected resources: #{missed_resources.join(', ')}"
    end
  end
end
