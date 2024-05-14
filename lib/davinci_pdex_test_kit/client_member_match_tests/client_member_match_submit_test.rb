require_relative '../urls'

module DaVinciPDexTestKit
  class PDexClientMemberMatchSubmitTest < Inferno::Test
    include URLs

    id :initial_member_match_submit_test
    title 'Client makes a $member_match request'
    description %(
      $MEMBER-MATCH DESCRIPTION
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
