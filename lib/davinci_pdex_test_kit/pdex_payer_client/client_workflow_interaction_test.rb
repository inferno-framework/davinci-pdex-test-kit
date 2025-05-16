require 'smart_app_launch_test_kit'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientWorkflowInteractionTest < Inferno::Test
      id :pdex_client_workflow_interaction
      title 'Client makes requests to Inferno'
      description %(
        This test will await requests from the client under test to demonstrate
        the payer to payer data access workflow, including
        - $member-match requests
        - clinical data requests, including resource read and searches, patient-level $everything,
          and group-level $export.
      )
      input :client_id,
            title: 'Client Id',
            type: 'text',
            optional: true,
            locked: true,
            description: SMARTAppLaunch::INPUT_CLIENT_ID_DESCRIPTION_LOCKED
      input :smart_launch_urls,
            title: 'SMART App Launch URL(s)',
            type: 'textarea',
            locked: true,
            optional: true,
            description: SMARTAppLaunch::INPUT_SMART_LAUNCH_URLS_DESCRIPTION_LOCKED
      input :launch_context,
            title: 'Launch Context',
            type: 'textarea',
            optional: true,
            description: SMARTAppLaunch::INPUT_LAUNCH_CONTEXT_DESCRIPTION       
      input :fhir_user_relative_reference,
            title: 'FHIR User Relative Reference',
            type: 'text',
            optional: true,
            description: SMARTAppLaunch::INPUT_FHIR_USER_RELATIVE_REFERENCE
      input_order :launch_context, :fhir_user_relative_reference, :smart_launch_urls, :client_id
      output :launch_key
      config options: { accepts_multiple_requests: true }

      verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@27', 'hl7.fhir.us.davinci-pdex_2.0.0@41'

      run do
        wait(
          identifier: client_id,
          message: %(
            Submit PDex requests to find a matching member and retrieve clinical data covering the
            complete scope of [member health history data defined by
            PDex](https://hl7.org/fhir/us/davinci-pdex/STU2/introduction.html#member-health-history)
            to the simulated FHIR server at

            `#{fhir_base_url}`
            
            Available APIs include:
            * Single patient $member-match: `#{member_match_url}`
            * Single Resource read and search API: `#{resource_url}`, with `:endpoint` replaced with
              the target resource type.
            * Patient-level $everything: `#{everything_url}`, with `:patient` replaced with the
              id for the target patient.
            * All Patients $export: see workflow process at
              the [Bulk Data IG](https://hl7.org/fhir/uv/bulkdata/STU2/export.html#sequence-overview)
              * Kick-off requests: `#{export_url}`.
              * Export status requests: `#{export_status_url}?_jobId=:job` as returned in the `content-location`
                header of the kick-off request response.
              * Retrieval file Requests: `#{binary_url}` with `:id` replaced with an actual id as indicated
                in the JSON manifest returned with the export status request when the job is completed.
                Note that the `Accept` header should be `application/fhir+ndjson` on these requests.

            All requests must include the `Authorization` header with value `Bearer <access_token>`
            where `<access_token>` is a token obtained using the registered client id `#{client_id}`.

            [Click here](#{resume_clinical_data_url}?token=#{client_id}) when finished making requests
            for Inferno to evaluate.
          ),
          timeout: 900
        )
      end
    end
  end
end
