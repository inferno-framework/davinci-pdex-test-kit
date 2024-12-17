# frozen_string_literal: true

module DaVinciPDexTestKit
  module PDexPayerServer
    class WorkflowClinicalDataGroup < Inferno::TestGroup
      id :pdex_workflow_clinical_data_group
      title 'Server can respond to search requests for clinical data on the matched patient'
      short_title 'Clinical data query'
      description %{
        # Background
        The [PDex Implementation Guide](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#query-all-clinical-resources-individually)
        requires Payer servers to support querying of individual clinical resources from
        its Patient's Member Identifier (aka Patient FHIR ID). This test sequence simulates that step
        in the workflow by querying for encounters. The full read and search API is tested in
        its own test group.

        # Test Methodology
        If the $member-match tests were run and returned a valid member-match-response, then it's
        patient's id will be used for the query. If not, then the user inputted Patient id is used
        for this test. If neither is available tests are skipped.
      }

      input :patient_id,
        title: 'Patient ID',
        description: 'Manual Patient ID for testing Clinical Query and $everything without $member-match.',
        optional: true

      test do
        id :pdex_workflow_clinical_encounter_query_test
        title 'Server can provide clinical Encounter data from matched member identifier'
        description %{
          Server receives request `GET [baseURL]/Encounter?subject=Patient/[id]` and returns 200.
        }

        makes_request :pdex_clinical_query

        run do
          skip_if !patient_id,
            'No Patient FHIR ID was derived from $member-match response or supplied by user input'

          fhir_search(FHIR::Encounter, params: {patient: "Patient/#{patient_id}"}, name: :pdex_clinical_query)
          assert_response_status(200)
        end
      end

      test do
        id :pdex_workflow_clinical_encounter_test
        title 'Server returned Search bundle with valid Encounter data'
        description %{
            Server returned search Bundle of Encounters with least 1 resource entry.
        }

        uses_request :pdex_clinical_query

        run do
          assert_valid_resource
          assert_resource_type('Bundle')
          assert resource.entry.length > 0, 'Response Bundle must have at least one entry'
          assert resource.entry.map{|entry| entry.resource}.all? { |res| res.resourceType == 'Encounter' },
                 'Response Bundle must only have Encounter resources'
        end
      end
    end
  end
end

