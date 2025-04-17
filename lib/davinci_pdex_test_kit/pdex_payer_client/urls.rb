# frozen_string_literal: true

module DaVinciPDexTestKit
  module PDexPayerClient

    module URLs
      BASE_PATH = "#{Inferno::Application['base_url']}/custom/pdex_payer_client"
      PATIENT_PATH = '/fhir/Patient'
      RESOURCE_PATH = '/fhir/:endpoint'
      INSTANCE_PATH = '/fhir/:endpoint/:id'
      SUBMIT_PATH = '/fhir/:endpoint'   # FIXME duplicate
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

      constants.each do |path_constant|
        # For each constant X_PATH, define x_path()
        define_method(path_constant.to_s.downcase.to_sym) do
          URLs.const_get(path_constant)
        end

        # For each constant X_PATH, define x_url(), which includes base
        define_method(path_constant.to_s.downcase.gsub(/_path$/, '_url')) do
          File.join(BASE_PATH, URLs.const_get(path_constant))
        end
      end

      # overwrite base_url which is irregular
      def base_url
        BASE_PATH
      end

      # overwrite base_fhir_url which is irregular
      def base_fhir_url
        File.join(BASE_PATH, BASE_FHIR_PATH)
      end

    end

    # Add all constants and dynamically defined methods to PDexPayerClient namespace
    include URLs
  end
end
