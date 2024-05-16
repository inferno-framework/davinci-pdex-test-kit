require_relative '../urls'

module DaVinciPDexTestKit
  class PDexClientMemberMatchSubmitTest < Inferno::Test
    include URLs

    id :initial_member_match_submit_test
    title 'Client makes a $member-match request'
    description %(
      This test will await a $member-match request and proceed once a request is received.
    )
    input :access_token

    run do
      wait(
        identifier: access_token,
        message: %(
          Submit a PDex $member-match request to `#{member_match_url}`.
        )
      )
    end
  end
end
