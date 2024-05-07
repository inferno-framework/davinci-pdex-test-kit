require_relative '../urls'

module DaVinciPDexTestKit
  class PDexClientMemberMatchMustSupportSubmitTest < Inferno::Test
    include URLs

    id :initial_member_match_must_support_submit_test
    title 'Client makes a $member_match request'
    description %(
      $MEMBER-MATCH DESCRIPTION
    )
    input :access_token
    config options: { accepts_multiple_requests: true }

    run do
      wait(
        identifier: access_token,
        message: %(
          Submit PDex $member-match request(s) to `#{member_match_url}`, and [click here](#{resume_pass_url}?token=#{access_token}) when all Must Support
          elements have been covered.
        )
      )
    end
  end
end
