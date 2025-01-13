module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientMemberMatchSubmitTest < Inferno::Test
  
      id :pdex_initial_member_match_submit_test
      title 'Client makes a $member-match request'
      description %(
        This test will await a $member-match request and proceed once a request is received.
      )
      input :access_token
  
      run do
        wait(
          identifier: access_token,
          message: %(
            Access Token: #{access_token} \n
            Submit a PDex $member-match request to `#{member_match_url}`.
          )
        )
      end
    end
  end
end
