# frozen_string_literal: true

module DaVinciPDexTestKit
  module PDexPayerServer
    RESUME_PASS_PATH = '/resume_pass'
    RESUME_FAIL_PATH = '/resume_fail'

    # URLs
    module URLs
      def base_url
        @base_url ||= "#{Inferno::Application['base_url']}/custom/#{suite_id}"
      end

      def resume_pass_url
        @resume_pass_url ||= base_url + RESUME_PASS_PATH
      end

      def resume_fail_url
        @resume_fail_url ||= base_url + RESUME_FAIL_PATH
      end

      def suite_id
        PDexPayerServerSuite.id
      end
    end
  end
end
