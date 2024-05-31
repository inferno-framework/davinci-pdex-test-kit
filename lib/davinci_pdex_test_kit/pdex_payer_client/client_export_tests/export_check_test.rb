require_relative '../../urls'
require_relative '../client_validation_test'

module DaVinciPDexTestKit
  class PDexClientExportCheckTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :export_check_test
    title '$export check'
    description %(
      checks status of previous export
    )
    input :access_token

    run do
      assert export_request.status == 202, "Expected status 202, got #{export_request.status}"
      assert !export_request.response_header('content-location').nil?, "No Content-Location header for the export payload"
      # wait(
      #   identifier: access_token,
      #   message: %(
      #     Submit PDex export status request(s) to `#{export_url}`.
      #   )
      # )
    end
  end
end
