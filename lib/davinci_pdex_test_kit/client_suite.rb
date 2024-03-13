require 'inferno/dsl/oauth_credentials'
require_relative 'ext/inferno_core/record_response_route'
require_relative 'ext/inferno_core/runnable'
require_relative 'ext/inferno_core/request'
require_relative 'urls'
require_relative 'mock_server'
require_relative 'tags'
require_relative 'collection'
require_relative 'initial_wait_test'
#require_relative 'span_test' #TODO: WIP
require_relative 'generated/Patient__id'
require_relative 'generated/AllergyIntolerance_patient'
require_relative 'generated/Condition_patient'
require_relative 'generated/Device_patient'
require_relative 'generated/DiagnosticReport_patient'
require_relative 'generated/DocumentReference_patient'
require_relative 'generated/Encounter_patient'
require_relative 'generated/Goal_patient'
require_relative 'generated/Immunization_patient'
require_relative 'generated/Procedure_patient'

module DaVinciPDEXTestKit
  class ClientSuite < Inferno::TestSuite
    extend MockServer

    id :client_suite_v201
    title 'DaVinci PDEX Client Suite v2.0.1'
    description %(
      The DaVinci PDEX Test Kit Client Suite validates client conformance to the
      HL7® FHIR® [Davinci Prior Authorization Support Implementation Guide](https://hl7.org/fhir/us/davinci-pas/STU2/).
    )

    links [
      {
        label: 'Implementation Guide',
        url: 'https://hl7.org/fhir/us/davinci-pas/STU2/'
      }
    ]

    def self.test_resumes?(test)
      !test.config.options[:accepts_multiple_requests]
    end

    validator do
      url ENV.fetch('VALIDATOR_URL')

      exclude_message do |message|
        # Messages expected of the form `<ResourceType>: <FHIRPath>: <message>`
        # We strip `<ResourceType>: <FHIRPath>: ` for the sake of matching
        SUPPRESSED_MESSAGES.match?(message.message.sub(/\A\S+: \S+: /, ''))
      end
    end

    record_response_route :post, TOKEN_PATH, AUTH_TAG, method(:token_response) do |request|
      ClientSuite.extract_client_id(request)
    end

    record_response_route :get, SUBMIT_PATH, SUBMIT_TAG, method(:claim_response),
                          resumes: method(:test_resumes?) do |request|
      ClientSuite.extract_token_from_query_params(request)
    end

    resume_test_route :get, RESUME_PASS_PATH do |request|
      ClientSuite.extract_token_from_query_params(request)
    end

    resume_test_route :get, RESUME_FAIL_PATH, result: 'fail' do |request|
      ClientSuite.extract_token_from_query_params(request)
    end

    group do
      title "Series of Requests Test Group"
      test from: :initial_wait_test
      test from: :placeholder_verify_patient_test
      test from: :placeholder_verify_allergyintolerance_test
      test from: :placeholder_verify_condition_test
      test from: :placeholder_verify_device_test
      test from: :placeholder_verify_diagnosticreport_test
      test from: :placeholder_verify_documentreference_test
      test from: :placeholder_verify_encounter_test
      test from: :placeholder_verify_goal_test
      test from: :placeholder_verify_immunization_test
      test from: :placeholder_verify_procedure_test
      #test from: :placeholder_span_test
    end
  end
end
