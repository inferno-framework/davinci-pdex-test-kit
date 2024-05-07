module DaVinciPDexTestKit
  TOKEN_PATH = '/mock_auth/token'
  SUBMIT_PATH = '/fhir/:endpoint'
  MEMBER_MATCH_PATH = '/fhir/Patient/member-match'
  RESUME_PASS_PATH = '/resume_pass'
  RESUME_FAIL_PATH = '/resume_fail'

  module URLs
    def base_url
      @base_url ||= "#{Inferno::Application['base_url']}/custom/#{suite_id}"
    end

    def token_url
      @token_url ||= base_url + TOKEN_PATH
    end

    def submit_url
      @submit_url ||= base_url + SUBMIT_PATH
    end

    def member_match_url
      @member_match_url ||= base_url + MEMBER_MATCH_PATH
    end

    def resume_pass_url
      @resume_pass_url ||= base_url + RESUME_PASS_PATH
    end

    def resume_fail_url
      @resume_fail_url ||= base_url + RESUME_FAIL_PATH
    end

    def suite_id
      self.class.suite.id
    end
  end
end
