module DaVinciPDexTestKit
  TOKEN_PATH = '/mock_auth/token'
  PATIENT_PATH = '/fhir/Patient'
  SUBMIT_PATH = '/fhir/:endpoint'
  METADATA_PATH = '/fhir/metadata'
  EVERYTHING_PATH = '/fhir/Patient/:patient/$everything'
  MEMBER_MATCH_PATH = '/fhir/Patient/$member-match'
  EXPORT_PATH = '/fhir/Patient/$export'
  RESUME_PASS_PATH = '/resume_pass'
  RESUME_CLINICAL_DATA_PATH = '/resume_clinical_data'
  RESUME_FAIL_PATH = '/resume_fail'

  module URLs
    def base_url
      @base_url ||= "#{Inferno::Application['base_url']}/custom/#{suite_id}"
    end

    def token_url
      @token_url ||= base_url + TOKEN_PATH
    end

    def patient_url
      @patient_url ||= base_url + PATIENT_PATH
    end

    def submit_url
      @submit_url ||= base_url + SUBMIT_PATH
    end

    def metadata_url
      @metadata_url ||= base_url + METADATA_PATH
    end

    def everything_url
      @everything_url ||= base_url + EVERYTHING_PATH
    end

    def member_match_url
      @member_match_url ||= base_url + MEMBER_MATCH_PATH
    end

    def export_url
      @export_url ||= base_url + EXPORT_PATH
    end

    def resume_pass_url
      @resume_pass_url ||= base_url + RESUME_PASS_PATH
    end

    def resume_clinical_data_url
      @resume_clinical_data_url ||= base_url + RESUME_CLINICAL_DATA_PATH
    end

    def resume_fail_url
      @resume_fail_url ||= base_url + RESUME_FAIL_PATH
    end

    def suite_id
      self.class.suite.id
    end
  end
end
