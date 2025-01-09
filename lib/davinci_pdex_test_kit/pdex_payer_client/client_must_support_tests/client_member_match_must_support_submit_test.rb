module DaVinciPDexTestKit
  class PDexPayerClientSuite
    class PDexClientMemberMatchMustSupportSubmitTest < Inferno::Test
  
      id :pdex_initial_member_match_must_support_submit_test
      title '$member-match requests span all Must Supports'
      description %(
        This test will receive $member-match requests until the user specifies they are done.  It then checks all received $member-match requests for Must Support coverage.
      )
      input :access_token
      config options: { accepts_multiple_requests: true }
  
      run do
        wait(
          identifier: access_token,
          message: %(
            Access Token: #{access_token} \n
            Submit PDex $member-match request(s) to `#{member_match_url}`, and [click here](#{resume_pass_url}?token=#{access_token}) when all Must Support
            elements have been covered.
          )
        )
      end
    end
  end
end
