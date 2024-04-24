require 'inferno/dsl/oauth_credentials'
require_relative 'ext/inferno_core/record_response_route'
require_relative 'ext/inferno_core/runnable'
require_relative 'ext/inferno_core/request'
require_relative 'urls'
require_relative 'mock_server'
require_relative 'tags'
require_relative 'collection'
require_relative 'initial_wait_test'
require_relative 'initial_request_logging'

module DaVinciPDexTestKit
    class PDexPayerClientSuite < Inferno::TestSuite
      extend MockServer

      id :pdex_payer_client
      title 'Da Vinci PDex Payer Client Test Suite'
      description %(
        # Da Vinci PDex Payer Client Test Suite

        This suite validates that a payer system can act as a client
        retrieving patient data from another payer system using
        payer to payer exchange as described in the PDex implementation
        guide. Inferno will act as a payer server that the 
        system under test will connect to and retrieve data from.
      )

      def self.test_resumes?(test)
        !test.config.options[:accepts_multiple_requests]
      end
      
      # All FHIR validation requests will use this FHIR validator
      validator do
        url ENV.fetch('VALIDATOR_URL')

        exclude_message do |message|
          # Messages expected of the form `<ResourceType>: <FHIRPath>: <message>`
          # We strip `<ResourceType>: <FHIRPath>: ` for the sake of matching
          SUPPRESSED_MESSAGES.match?(message.message.sub(/\A\S+: \S+: /, ''))
        end  
      end

      record_response_route :post, TOKEN_PATH, AUTH_TAG, method(:token_response) do |request|
        PDexPayerClientSuite.extract_client_id(request)
      end
  
      record_response_route :get, SUBMIT_PATH, SUBMIT_TAG, method(:claim_response),
                            resumes: method(:test_resumes?) do |request|
        PDexPayerClientSuite.extract_token_from_query_params(request)
      end
  
      resume_test_route :get, RESUME_PASS_PATH do |request|
        PDexPayerClientSuite.extract_token_from_query_params(request)
      end
  
      resume_test_route :get, RESUME_FAIL_PATH, result: 'fail' do |request|
        PDexPayerClientSuite.extract_token_from_query_params(request)
      end

      group do
        title "Series of Requests Test Group"
        test from: :initial_wait_test
        test from: :initial_request_logging
      end
    end
  end
  