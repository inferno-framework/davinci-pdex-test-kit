require_relative 'pdex_payer_client/pdex_client_options'
require_relative 'pdex_payer_client/urls'
require_relative 'pdex_payer_client/tags'
require_relative 'pdex_payer_client/collection'
require_relative 'pdex_payer_client/mock_server'
# require_relative 'must_support_test'
# require_relative 'pdex_payer_client/client_validation_test'

require_relative 'remove_input'

require_relative 'pdex_payer_client/client_registration_group'
require_relative 'pdex_payer_client/client_auth_smart_alca_group'
require_relative 'pdex_payer_client/client_auth_smart_alcs_group'
require_relative 'pdex_payer_client/client_auth_smart_alp_group'
require_relative 'pdex_payer_client/client_auth_udap_group'
require_relative 'pdex_payer_client/client_workflow_interaction_test'
require_relative 'pdex_payer_client/client_member_match_tests/client_member_match_validation_test'

require_relative 'pdex_payer_client/clinical_data_request_tests/clinical_data_request_check_test'
require_relative 'pdex_payer_client/clinical_data_request_tests/patient_id_search_request_check_test'
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

require_relative 'pdex_payer_client/visual_inspection_and_attestation'

module DaVinciPDexTestKit
  class PDexPayerClientSuite < Inferno::TestSuite
    include PDexPayerClient
    include PDexPayerClient::URLs
    include PDexPayerClient::MockServer

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

    requirement_sets(
      {
        identifier: 'hl7.fhir.us.davinci-pdex_2.0.0',
        title: 'Da Vinci Payer Data Exchange (PDex) v2.0.0',
        actor: 'Client'
      }
    )

    suite_option  :client_type,
                  title: 'Client Security Type',
                  list_options: [
                    {
                      label: 'SMART App Launch Public Client',
                      value: PDexClientOptions::SMART_APP_LAUNCH_PUBLIC
                    },
                    {
                      label: 'SMART App Launch Confidential Symmetric Client',
                      value: PDexClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
                    },
                    {
                      label: 'SMART App Launch Confidential Asymmetric Client',
                      value: PDexClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
                    },
                    {
                      label: 'UDAP Authorization Code Client',
                      value: PDexClientOptions::UDAP_AUTHORIZATION_CODE
                    }
                  ]

    resume_test_route :get, RESUME_PASS_PATH do |request|
      PDexPayerClientSuite.extract_token_from_query_params(request)
    end

    resume_test_route :get, RESUME_CLINICAL_DATA_PATH do |request|
      PDexPayerClientSuite.extract_token_from_query_params(request)
    end

    resume_test_route :get, RESUME_FAIL_PATH, result: 'fail' do |request|
      PDexPayerClientSuite.extract_token_from_query_params(request)
    end

    group from: :pdex_client_registration

    group do
      run_as_group
      title 'Verify PDex Data Access'
      id :payer_to_payer_workflow

      group do
        title 'Interaction Tests'
        id :pdex_client_workflow_interaction

        test from: :pdex_client_workflow_interaction
      end

      group from: :pdex_client_auth_smart_alca,
          required_suite_options: {
            client_type: PDexClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_ASYMMETRIC
          }
      group from: :pdex_client_auth_smart_alcs,
            required_suite_options: {
              client_type: PDexClientOptions::SMART_APP_LAUNCH_CONFIDENTIAL_SYMMETRIC
            }
      group from: :pdex_client_auth_smart_alp,
            required_suite_options: {
              client_type: PDexClientOptions::SMART_APP_LAUNCH_PUBLIC
            }
      group from: :pdex_client_auth_udap,
            required_suite_options: {
              client_type: PDexClientOptions::UDAP_AUTHORIZATION_CODE
            }

      group do
        title '$member-match validation'
        id :member_match_validation

        test from: :pdex_initial_member_match_validation
      end

      group do
        title 'Clinical data request validation'
        id :clinical_data_validation

        test from: :pdex_clinical_data_request_check
        test from: :pdex_patient_id_search_request_check
        test from: :pdex_allergyintolerance_clinical_data_request
        test from: :pdex_careplan_clinical_data_request
        test from: :pdex_careteam_clinical_data_request
        test from: :pdex_condition_clinical_data_request
        test from: :pdex_device_clinical_data_request
        test from: :pdex_diagnosticreport_clinical_data_request
        test from: :pdex_documentreference_clinical_data_request
        test from: :pdex_encounter_clinical_data_request
        test from: :pdex_explanationofbenefit_clinical_data_request
        test from: :pdex_goal_clinical_data_request
        test from: :pdex_immunization_clinical_data_request
        test from: :pdex_location_clinical_data_request
        test from: :pdex_medicationdispense_clinical_data_request
        test from: :pdex_medicationrequest_clinical_data_request
        test from: :pdex_observation_clinical_data_request
        test from: :pdex_organization_clinical_data_request
        test from: :pdex_patient_clinical_data_request
        test from: :pdex_practitioner_clinical_data_request
        test from: :pdex_practitionerrole_clinical_data_request
        test from: :pdex_procedure_clinical_data_request
      end
    end

    group from: :pdex_client_visual_inspection_and_attestation do
      optional
    end
    RemoveInput::recursive_remove_input(groups.last, :url)


    # TODO: must support validation



    private

    def self.extract_token_from_query_params(request)
      request.query_parameters['token']
    end
  end
end
