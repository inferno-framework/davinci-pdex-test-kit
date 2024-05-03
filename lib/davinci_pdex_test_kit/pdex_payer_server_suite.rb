# frozen_string_literal: true

require_relative 'pdex_payer_server/dollar_everything'

module DaVinciPDexTestKit
    class PDexPayerServerSuite < Inferno::TestSuite
      id :pdex_payer_server
      title 'Da Vinci PDex Payer Server Test Suite'
      description %(
        # Da Vinci PDex Payer Server Test Suite

        This suite validates that a payer system can act as a
        data source for client systems to connect to and retrieve
        data from. This includes provider systems as well as other
        payer systems using the payer to payer data retrieval approach.
        Inferno will act as a client system connecting to the system
        under test and making requests for data against it.
      )
  
      # These inputs will be available to all tests in this suite
      input :url,
            title: 'FHIR Server Base Url'
  
      input :credentials,
            title: 'OAuth Credentials',
            type: :oauth_credentials,
            optional: true
  
      # All FHIR requests in this suite will use this FHIR client
      fhir_client do
        url :url
        oauth_credentials :credentials
      end
  
      # All FHIR validation requsets will use this FHIR validator
      validator do
        url ENV.fetch('VALIDATOR_URL')
      end

      group do
        title 'Payer to Payer Workflow'
        id :payer_to_payer_workflow

        group do
          title 'server can return a matching member in response to a $member-match request'
          id :workflow_member_match
        end

        group do
          title 'server can respond to search requests for clinical data on the matched patient'
          id :workflow_clinical_data
        end
        
        # /Patient/$everything tests
        group from: :dollar_everything

        group do
          title 'server can respond to $export requests on the matched patient'
          id :workflow_export
        end
      end
      group do
        title 'API Capability and Must Support Coverage'
        id :api_and_must_support_coverage

        group do
          title 'Search and Read API'
          id :search_and_read_api_coverage
          # Import all US Core v3.1.1 groups without the Suite
          Dir.glob(File.join($LOAD_PATH.find { |x| x.match? "us_core_test_kit" }, 'us_core_test_kit/generated/v3.1.1/*_group.rb')).each do |test_group_path|
            require_relative test_group_path

            group from: "us_core_v311_#{File.basename(test_group_path).gsub('_group.rb','')}".to_sym
          end

        end
      end

    end
  end
