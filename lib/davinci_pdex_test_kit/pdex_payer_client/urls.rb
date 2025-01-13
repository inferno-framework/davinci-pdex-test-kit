# frozen_string_literal: true

module DaVinciPDexTestKit
  module PDexPayerClient

    # TODO metaprogram:

    TOKEN_PATH = '/mock_auth/token'
    PATIENT_PATH = '/fhir/Patient'
    RESOURCE_PATH = '/fhir/:endpoint'
    BINARY_PATH = '/fhir/Binary/:id'
    METADATA_PATH = '/fhir/metadata'
    EVERYTHING_PATH = '/fhir/Patient/:patient/$everything'
    MEMBER_MATCH_PATH = '/fhir/Patient/$member-match'
    EXPORT_PATH = '/fhir/Patient/$export'
    EXPORT_STATUS_PATH = '/fhir/$export-poll-status'
    BASE_FHIR_PATH = '/fhir'
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
      
      def base_fhir_url
        @base_fhir_url ||= base_url + BASE_FHIR_PATH
      end
  
      def patient_url
        @patient_url ||= base_url + PATIENT_PATH
      end
  
      def submit_url
        @submit_url ||= base_url + RESOURCE_PATH
      end
  
      def binary_url
        @binary_url ||= base_url + BINARY_PATH
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
  
      def export_status_url
        @export_status_url ||= base_url + EXPORT_STATUS_PATH
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

      private
  
      def suite_id
        self.class.suite.id
      end
  
    end
  end
end
