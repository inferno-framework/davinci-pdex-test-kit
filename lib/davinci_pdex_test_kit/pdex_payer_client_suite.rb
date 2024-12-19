require 'inferno/dsl/oauth_credentials'
require_relative 'endpoints/token_endpoint'
require_relative 'endpoints/resource_api_endpoint'
require_relative 'endpoints/binary_endpoint'
require_relative 'endpoints/patient_everything_endpoint'
require_relative 'endpoints/export_endpoint'
require_relative 'endpoints/export_status_endpoint'
require_relative 'endpoints/member_match_endpoint'
require_relative 'endpoints/next_page_endpoint'
require_relative 'urls'
require_relative 'mock_server'
require_relative 'tags'
require_relative 'pdex_payer_client/collection'
require_relative 'must_support_test'
require_relative 'pdex_payer_client/client_validation_test'

require_relative 'pdex_payer_client/clinical_data_request_tests/initial_wait_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/initial_scratch_storing'
require_relative 'pdex_payer_client/clinical_data_request_tests/allergyintolerance_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/careplan_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/careteam_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/condition_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/device_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/diagnosticreport_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/documentreference_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/encounter_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/explanationofbenefit_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/goal_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/immunization_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/location_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/medicationdispense_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/medicationrequest_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/observation_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/organization_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/patient_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/practitioner_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/practitionerrole_clinical_data_request_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/procedure_clinical_data_request_test'

require_relative 'pdex_payer_client/client_member_match_tests/client_member_match_submit_test'
require_relative 'pdex_payer_client/client_member_match_tests/client_member_match_validation_test'
# require_relative 'pdex_payer_client/client_must_support_tests/client_member_match_must_support_submit_test'
# require_relative 'pdex_payer_client/client_must_support_tests/client_member_match_must_support_validation_test'


module DaVinciPDexTestKit
    class PDexPayerClientSuite < Inferno::TestSuite
      extend MockServer
      extend ClientValidationTest

      id :pdex_payer_client
      title 'Da Vinci PDex Payer Client Test Suite'
      description File.read(File.join(__dir__, 'docs', 'payer_client_suite_description_v200.md'))
      
      links [
        {
          label: 'Report Issue',
          url: 'https://github.com/inferno-framework/davinci-pdex-test-kit/issues'
        },
        {
          label: 'Open Source',
          url: 'https://github.com/inferno-framework/davinci-pdex-test-kit'
        },
        {
          label: 'Download',
          url: 'https://github.com/inferno-framework/davinci-pdex-test-kit/releases'
        },
        {
          label: 'Implementation Guide',
          url: 'https://hl7.org/fhir/us/davinci-pdex/STU2/'
        }
      ]

      # Hl7 Validator Wrapper:
      fhir_resource_validator do
        igs 'hl7.fhir.us.davinci-pdex#2.0.0'
        # hrex 1.0.0 and other dependencies will auto-load

        exclude_message do |message|
          message.message.match?(/\A\S+: \S+: URL value '.*' does not resolve/)
        end
      end

      suite_endpoint :post, TOKEN_PATH, TokenEndpoint

      suite_endpoint :get, PATIENT_PATH, ResourceAPIEndpoint

      suite_endpoint :get, RESOURCE_PATH, ResourceAPIEndpoint

      suite_endpoint :get, BINARY_PATH, BinaryEndpoint

      suite_endpoint :get, EVERYTHING_PATH, PatientEverythingEndpoint

      suite_endpoint :get, EXPORT_PATH, ExportEndpoint

      suite_endpoint :get, EXPORT_STATUS_PATH, ExportStatusEndpoint

      suite_endpoint :post, MEMBER_MATCH_PATH, MemberMatchEndpoint

      suite_endpoint :get, BASE_FHIR_PATH, NextPageEndpoint
  
      resume_test_route :get, RESUME_PASS_PATH do |request|
        PDexPayerClientSuite.extract_token_from_query_params(request)
      end

      resume_test_route :get, RESUME_CLINICAL_DATA_PATH do |request|
        PDexPayerClientSuite.extract_token_from_query_params(request)
      end
  
      resume_test_route :get, RESUME_FAIL_PATH, result: 'fail' do |request|
        PDexPayerClientSuite.extract_token_from_query_params(request)
      end

      route(:get, METADATA_PATH, get_metadata)

      group do
        run_as_group
        title "Workflow Tests"
        group do
          title "$member-match validation"
          test from: :initial_member_match_submit_test
          test from: :initial_member_match_validation_test
        end
        group do
          title "Clinical data request tests"
          test from: :initial_wait_test
          test from: :initial_scratch_storing
          test from: :allergyintolerance_clinical_data_request_test
          test from: :careplan_clinical_data_request_test
          test from: :careteam_clinical_data_request_test
          test from: :condition_clinical_data_request_test
          test from: :device_clinical_data_request_test
          test from: :diagnosticreport_clinical_data_request_test
          test from: :documentreference_clinical_data_request_test
          test from: :encounter_clinical_data_request_test
          test from: :explanationofbenefit_clinical_data_request_test
          test from: :goal_clinical_data_request_test
          test from: :immunization_clinical_data_request_test
          test from: :location_clinical_data_request_test
          test from: :medicationdispense_clinical_data_request_test
          test from: :medicationrequest_clinical_data_request_test
          test from: :observation_clinical_data_request_test
          test from: :organization_clinical_data_request_test
          test from: :patient_clinical_data_request_test
          test from: :practitioner_clinical_data_request_test
          test from: :practitionerrole_clinical_data_request_test
          test from: :procedure_clinical_data_request_test
        end
      end
      
      # group do
      #   title "Must Support validation"
      #   group do
      #     title "$member-match Must Support tests"
      #     test from: :initial_member_match_must_support_submit_test
      #     test from: :initial_member_match_must_support_validation_test
      #   end
      # end
    end
  end
  
