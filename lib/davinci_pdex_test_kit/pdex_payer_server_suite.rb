require 'us_core_test_kit/generated/v3.1.1/us_core_test_suite'

require_relative 'remove_input'

require_relative 'pdex_payer_server/workflow_member_match_group'
require_relative 'pdex_payer_server/workflow_clinical_data_group'
require_relative 'pdex_payer_server/workflow_everything_group'
require_relative 'pdex_payer_server/workflow_export_group'

require_relative 'pdex_payer_server/no_member_matches_group'
require_relative 'pdex_payer_server/multiple_member_matches_group'

require_relative 'pdex_payer_server/explanation_of_benefit_group'
require_relative 'pdex_payer_server/device_group'
require_relative 'pdex_payer_server/medication_dispense_group'
require_relative 'pdex_payer_server/provenance_group'

require_relative 'pdex_payer_server/urls'
require_relative 'pdex_payer_server/visual_inspection_and_attestation'

module DaVinciPDexTestKit
  class PDexPayerServerSuite < Inferno::TestSuite
    id :pdex_payer_server
    title 'Da Vinci PDex Payer Server Test Suite'
    description File.read(File.join(__dir__, 'docs', 'payer_server_suite_description_v200.md'))

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

    requirement_sets(
      {
        identifier: 'hl7.fhir.us.davinci-pdex_2.0.0',
        title: 'Da Vinci Payer Data Exchange (PDex) v2.0.0',
        actor: 'Server'
      },
      {
        identifier: 'hl7.fhir.uv.bulkdata_2.0.0',
        title: 'Bulk Data Access IG',
        actor: 'Server'
      }
    )

    input :url,
          title: 'FHIR Server Base Url'

    VALIDATION_MESSAGE_FILTERS = [
      /Observation\.effective\.ofType\(Period\): .*vs-1:/, # Invalid invariant in FHIR v4.0.1
      /\A\S+: \S+: URL value '.*' does not resolve/
    ].freeze

    VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

    # Hl7 Validator Wrapper:
    fhir_resource_validator do
      igs 'hl7.fhir.us.davinci-pdex#2.0.0'
      # hrex 1.0.0 and other dependencies will auto-load

      # Copy messages limit from Bulk Data Export tests
      message_filters = VALIDATION_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

      $num_messages = 0
      $capped_message = false
      $num_errors = 0
      $capped_errors = false

      exclude_message do |message|
        matches_filter = message_filters.any? { |filter| filter.match? message.message }

        unless matches_filter
          if message.type == 'error'
            $num_errors += 1
          else
            $num_messages += 1
          end
        end

        matches_filter ||
          (message.type != 'error' && $num_messages > 50 && !message.message.include?('Inferno is only showing the first')) ||
          (message.type == 'error' && $num_errors > 20 && !message.message.include?('Inferno is only showing the first'))
      end

      perform_additional_validation do
        if $num_messages > 50 && !$capped_message
          $capped_message = true
          { type: 'info', message: 'Inferno is only showing the first 50 validation info and warning messages.' }
        elsif $num_errors > 20 && !$capped_errors
          $capped_errors = true
          { type: 'error', message: 'Inferno is only showing the first 20 validation error messages.' }
        end
      end
    end

    resume_test_route :get, PDexPayerServer::RESUME_PASS_PATH do |request|
      request.query_parameters['token']
    end
    resume_test_route :get, PDexPayerServer::RESUME_FAIL_PATH, result: 'fail' do |request|
      request.query_parameters['token']
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

      group from: :pdex_workflow_member_match
      group from: :pdex_workflow_clinical_data
      group from: :pdex_workflow_everything
      group from: :pdex_workflow_export
    end

    group do
      title 'API Capability and Must Support Coverage'
      id :api_and_ms_coverage

      verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@9', 'hl7.fhir.us.davinci-pdex_2.0.0@14'

      input :smart_auth_info,
            title: 'OAuth Credentials',
            type: :auth_info,
            optional: true

      fhir_client do
        url :url
        auth_info :smart_auth_info
      end

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

        input_order :url, :smart_auth_info, :no_member_match_request, :multiple_member_match_request

        group from: :pdex_no_member_matches
        group from: :pdex_multiple_member_matches
      end

      group do
        title 'PDEX Search and Read API (US Core plus additional PDex resource types)'
        id :pdex_fhir_api_coverage

        verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@3', 'hl7.fhir.us.davinci-pdex_2.0.0@7',
                              'hl7.fhir.us.davinci-pdex_2.0.0@16', 'hl7.fhir.us.davinci-pdex_2.0.0@43',
                              'hl7.fhir.us.davinci-pdex_2.0.0@44', 'hl7.fhir.us.davinci-pdex_2.0.0@48',
                              'hl7.fhir.us.davinci-pdex_2.0.0@49', 'hl7.fhir.us.davinci-pdex_2.0.0@50',
                              'hl7.fhir.us.davinci-pdex_2.0.0@51', 'hl7.fhir.us.davinci-pdex_2.0.0@52'

        group from: :pdex_eob
        group from: :pdex_device
        group from: :pdex_medication_dispense
        group from: :pdex_provenance

        # Import all US Core v3.1.1 groups without the Suite
        USCoreTestKit::USCoreV311::USCoreTestSuite.groups[1].groups.each do |group|
          # This prevents a second OAuth credentials box from appearing in UI
          group(from: group.ancestors[1].id, id: group.ancestors[1].id.delete_prefix('us_core_v311_'))
        end
      end
    end
    group from: :pdex_server_visual_inspection_and_attestation do
      optional
    end
    RemoveInput::recursive_remove_input(groups.last, :url)
  end
end
