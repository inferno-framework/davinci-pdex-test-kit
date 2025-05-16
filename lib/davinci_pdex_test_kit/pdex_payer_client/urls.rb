# frozen_string_literal: true

module DaVinciPDexTestKit
  module PDexPayerClient

    module URLs
      PATIENT_PATH = '/fhir/Patient'
      PATIENT_INSTANCE_PATH = '/fhir/Patient/:patient'
      RESOURCE_PATH = '/fhir/:endpoint'
      INSTANCE_PATH = '/fhir/:endpoint/:id'
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
      AUTHORIZATION_PATH = '/auth/authorization'
      TOKEN_PATH = '/auth/token'

      constants.each do |path_constant|
        # For each constant X_PATH, define x_path()
        define_method(path_constant.to_s.downcase.to_sym) do
          URLs.const_get(path_constant)
        end

        # For each constant X_PATH, define x_url(), which includes base
        define_method(path_constant.to_s.downcase.gsub(/_path$/, '_url')) do
          base_url + URLs.const_get(path_constant)
        end
      end

      def suite_id
        PDexPayerClientSuite.id
      end

      # overwrite base_url which is irregular
      def base_url
        @base_url ||= "#{Inferno::Application['base_url']}/custom/#{suite_id}"
      end

      # overwrite fhir_base_url which is irregular
      def fhir_base_url
        base_url + BASE_FHIR_PATH
      end

      # alias for smart and udap tests
      def client_fhir_base_url
        fhir_base_url
      end
    end

    # Add all constants and dynamically defined methods to PDexPayerClient namespace
    include URLs
  end
end
