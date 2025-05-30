require_relative 'patient_operation_in_capability_statement_validation'

module DaVinciPDexTestKit
  module PDexPayerServer
    class WorkflowEverythingGroup < Inferno::TestGroup
      title 'Server can respond to $everything requests on matched patient'
      short_title '$everything'
      id :pdex_workflow_everything
      optional
      description %{
        # Background

        The Patient $everything operation for Payer-to-Payer exchange. See
        [PDex Implementation Guide](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#everything-operation)
        and [FHIR R4 documentation](https://hl7.org/fhir/R4/patient-operation-everything.html).

        # Test Methodology

        This test sequence takes a patient id input and executes the `$everything` FHIR operation on it.
      }

      verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@42'

      input :patient_id,
            title: 'Patient ID',
            description: 'Manual Patient ID for testing Clinical Query and $everything $export without $member-match.',
            optional: true

      input :smart_auth_info,
            title: 'OAuth Credentials',
            type: :auth_info,
            optional: true

      fhir_client do
        url :url
        auth_info :smart_auth_info
      end

      test from: :pdex_patient_operation_in_cap_stmt_validation,
           title: 'Server declares support for Patient everything operation in CapabilityStatement',
           config: {
             options: { operation_name: 'everything', operation_url: 'http://hl7.org/fhir/OperationDefinition/Patient-everything' }
           }

      test do
        title 'Server can handle GET /Patient/[ID]/$everything'

        verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@46'

        makes_request :pdex_patient_everything

        run do
          skip_if !patient_id,
                  'No Patient FHIR ID was derived from $member-match response or supplied by user input'

          fhir_operation("/Patient/#{patient_id}/$everything", operation_method: :get, name: :pdex_patient_everything)

          assert_response_status 200
        end
      end

      test do
        title 'Server returns a Bundle resource with requested Patient resource, and all resources conform to FHIR R4'

        input :patient_id # borrows properties from workflow_clinical_data

        uses_request :pdex_patient_everything

        run do
          skip_if !patient_id
          'No Patient ID was derived from $member-match nor supplied from user input'
          skip_if response[:status] != 200, 'Skipped because previous test did not pass'

          assert_valid_resource
          assert_resource_type(:bundle)
          assert_valid_bundle_entries
          assert resource.entry.map(&:resource).map(&:resourceType).any?('Patient'),
                 'Bundle does not include a Patient resource'
          assert(resource.entry.map(&:resource).one? do |resource|
                   resource.resourceType == 'Patient' && resource.id == patient_id
                 end)
        end
      end

      # TODO: convert to attestation
      # test do
      #   title %{
      #     The resources returned SHALL include all the data covered by the meaningful use common data elements as
      #     defined in the US Core Implementation Guide
      #   }
      #   description %{
      #     See FHIR R4 documentation for [patient-everything](https://hl7.org/fhir/R4/patient-operation-everything.html).
      #     The US realm has now replaced meaningful use common data elements with [USCDI](https://www.healthit.gov/isa/united-states-core-data-interoperability-uscdi).

      #     This test currently uses `meta.profile` to validate that a resource is compliant with its intended profile,
      #     which includes checking for the profile's required elements.

      #     It is the servers responsiblity to return all resources necessary to cover all USDCI elements known by
      #     the server.
      #   }

      #   uses_request :pdex_patient_everything

      #   run do
      #     skip_if resource.resourceType != 'Bundle'

      #     (0...resource.entry.length).each do |i|
      #       assert_valid_resource(resource: resource.entry[i].resource,
      #                             profile_url: resource.entry[i].resource.meta.profile
      #                            )
      #     end
      #   end
      # end

      # TODO: make attestations clearer, possibly change UI
      # test do
      #   title %{
      #     Attestation: Server returns all resources necessary to cover all USDCI elements known by the server if
      #     operating in US Realm.
      #   }
      #   description 'See previous test for details.'

      #   input :workflow_everything_uscdi_attestation,
      #         title: %{
      #           Server's $everything operation returns all resources necessary to cover all USDCI
      #           elements known by the server if operating in US Realm
      #         },
      #         type: :radio,
      #         options: {
      #           list_options: [
      #             {
      #               label: 'Yes',
      #               value: 'yes'
      #             },
      #             {
      #               label: 'No',
      #               value: 'no'
      #             }
      #           ]
      #         },
      #         default: '',
      #         optional: true

      #   run do
      #     assert workflow_everything_uscdi_attestation == 'yes', 'Developer did not agree to attestation'
      #   end
      # end

      # test do
      #   title %{
      #     Attestation: The use of the Bulk FHIR specification for transmission of member $everything data SHALL
      #     honor jurisdictional and personal privacy restrictions that are relevant to a member’s health record.
      #   }

      #   input :workflow_everything_privacy_attestation,
      #         title: %Q(
      #           Server's $everything operation shall honor jurisdictional and personal privacy
      #           restriction that are relevant to a member's health record
      #         ),
      #         type: :radio,
      #         options: {
      #           list_options: [
      #             {
      #               label: 'Yes',
      #               value: 'yes'
      #             },
      #             {
      #               label: 'No',
      #               value: 'no'
      #             }
      #           ]
      #         },
      #         default: '',
      #         optional: true

      #   run do
      #     assert workflow_everything_privacy_attestation == 'yes', 'Developer did not agree to attestation'
      #   end
      # end

      # TODO: consider parameter tests
    end
  end
end
