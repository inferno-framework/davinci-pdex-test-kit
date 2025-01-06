require_relative '../tags'
require_relative '../mock_server'

module DaVinciPDexTestKit
  class ResourceAPIEndpoint < Inferno::DSL::SuiteEndpoint
    include DaVinciPDexTestKit::MockServer

    def test_run_identifier
      extract_bearer_token(request)
    end

    def make_response
      resource_response(request, test, result)
    end

    def tags
      [RESOURCE_REQUEST_TAG]
    end

    def update_result
      results_repo.update(result.id, result: 'pass') unless test.config.options[:accepts_multiple_requests]
    end
  end
end
