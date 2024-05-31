require_relative '../../urls'

module DaVinciPDexTestKit
  class PDexClientExportTest < Inferno::Test
    include URLs

    id :export_test
    title '$export'
    description %(
      $export
    )
    input :access_token

    run do
      wait(
        identifier: access_token,
        message: %(
          Submit PDex $member-match request(s) to `#{export_url}`.
        )
      )
    end
  end
end
