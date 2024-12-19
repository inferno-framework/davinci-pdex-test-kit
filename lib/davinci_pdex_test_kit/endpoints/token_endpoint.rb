require_relative '../tags'
require_relative '../mock_server'

module DaVinciPDexTestKit
  class TokenEndpoint < Inferno::DSL::SuiteEndpoint
    include DaVinciPDexTestKit::MockServer

    def test_run_identifier
      extract_client_id(request)
    end

    def make_response
      token_response(request)
    end

    def tags
      [AUTH_TAG]
    end

    def update_result
      results_repo.update(result.id, result: 'pass') unless test.config.options[:accepts_multiple_requests]
    end
  end
end
