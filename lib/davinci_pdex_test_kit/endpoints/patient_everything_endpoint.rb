require_relative '../tags'
require_relative '../mock_server'

module DaVinciPDexTestKit
  class PatientEverythingEndpoint < Inferno::DSL::SuiteEndpoint
    include DaVinciPDexTestKit::MockServer

    def test_run_identifier
      extract_bearer_token(request)
    end

    def make_response
      everything_response(request, test, result)
    end

    def tags
      [EVERYTHING_TAG]
    end

    def update_result
      results_repo.update(result.id, result: 'pass') unless test.config.options[:accepts_multiple_requests]
    end
  end
end
