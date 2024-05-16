# frozen_string_literal: true

require_relative 'pdex_payer_server/workflow_member_match'
require_relative 'pdex_payer_server/workflow_clinical_data'
require_relative 'pdex_payer_server/workflow_everything'
require_relative 'pdex_payer_server/workflow_export'

require_relative 'pdex_payer_server/no_member_matches_group'
require_relative 'pdex_payer_server/multiple_member_matches_group'

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
  
      input :url,
            title: 'FHIR Server Base Url'
  
      input :credentials,
            title: 'OAuth Credentials',
            type: :oauth_credentials,
            optional: true
  
      fhir_client do
        url :url
        oauth_credentials :credentials
      end
  
      validator do
        url ENV.fetch('VALIDATOR_URL')
      end

      group do
        title 'Payer to Payer Workflow'
        id :payer_to_payer_workflow
        description %(
          # Background

          This Payer to Payer Workflow test sequence is designed to simulate a realistic use case for
          data access on a Payer's FHIR Server. This workflow conforms to the Da Vinci
          [Payer Data Exchange (PDex) v2.0.0 Implementation Guide](https://hl7.org/fhir/us/davinci-pdex/STU2/),
          which itself relies on
          [Health Record Exchange (HRex) v1.0.0 Implementation Guide](https://hl7.org/fhir/us/davinci-hrex/index.html)
          and [US Core v3.1.1 Implementation Guide](http://hl7.org/fhir/us/core/STU3.1.1/). The PDex Implementation Guide contains more on
          the [business use case background](https://hl7.org/fhir/us/davinci-pdex/STU2/index.html#background), and the specific
          [payer-to-payer workflow](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html).

          # Testing Methodology

          This workflow is broken into four parts:

          1. Send a `$member-match` request to the Server to identify a Patient based on Payer's coverage plan and Patient consent.

          2. Use the identified Patient to query for specific clinical data.

          3. **Optional.** Send an `$everything` request to the server to query for all relevant clinical data on the Patient.

          4. **Optional.** Send an `$export` request to the server to query for all relevant clinical data on the Patient asynchronously.

          See the corresponding test group's description for the testing methodology of each part.
        )

        group from: :workflow_member_match
        group from: :workflow_clinical_data
        group from: :workflow_everything
        group from: :workflow_export
      end

      group do
        title 'API Capability and Must Support Coverage'
        id :api_and_must_support_coverage

        group do
          title '$member-match failure cases'
          id :member_match_failure_cases
          description %{
            # Background
            
            This test sequence is for the negative results specification in
            [member matching logic](http://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html#member-matching-logic)
            from HRex 1.0.0 Implementation Guide, and is required by the PDex 2.0.0 Implementation Guide.

            # Testing Methodology

            1. If provided, attempt no-match member match operation
              + validate input
              + POST request to server and validiate HTTP 422 response status
            2. If provided, attempt a multiple-match member match operation
              + validate input
              + POST request to server and validiate HTTP 422 response status
          }

          input_order :url, :credentials, :no_member_match_request, :multiple_member_match_request

          group from: :no_member_matches_group
          group from: :multiple_member_matches_group
        end

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
