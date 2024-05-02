# frozen_string_literal: true

module DaVinciPDexTestKit
  module PDexPayerServer

    # Test Group for /Patient/$everything FHIR operation
    class DollarEverythingTestGroup < Inferno::TestGroup
      title 'Patient $everything'
      id :dollar_everything
      optional
      description <<~MARKDOWN
        The Patient $everything operation for Payer-to-Payer exchange. See
        [PDex Implementation Guide](https://build.fhir.org/ig/HL7/davinci-epdx/pdeximplementationactorsinteractionsdatapayloadsandmethods.html#payer-to-payer-data-exchange)
        and [FHIR R4 documentation](https://hl7.org/fhir/R4/patient-operation-everything.html).
      MARKDOWN

      test do
        title 'Server asserts Patient instance operation $everything in Capability Statement'

        run do
          fhir_get_capability_statement

          assert_response_status 200
          assert(
            resource.rest.one? do |rest_metadata|
              rest_metadata.resource.select { |resource_metadata| resource_metadata.type == 'Patient' }.first
                .operation.any? do |operation_metadata|
                  operation_metadata.name == '$everything' && operation_metadata.canonical == 'http://hl7.org/fhir/OperationDefinition/Patient-everything'
                end
            end
          )
        end
      end

      test do
        title 'Server can handle GET /Patient/[ID]/$everything'
        input :patient_id, title: 'Patient ID'
        output :patient_id
        makes_request :patient_everything

        run do
          fhir_operation("/Patient/#{patient_id}/$everything", operation_method: :get, name: :patient_everything)

          assert_response_status 200
        end
      end

      test do
        title 'Server returns a Bundle resource with requested Patient resource, and all resources conform to FHIR R4'
        input :patient_id
        uses_request :patient_everything

        run do
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

      test do
        title <<~PLAIN_TEXT
          The resources returned SHALL include all the data covered by the meaningful use common data elements as
          defined in the US Core Implementation Guide
        PLAIN_TEXT
        description <<~MARKDOWN
          See FHIR R4 documentation for [patient-everything](https://hl7.org/fhir/R4/patient-operation-everything.html).
          The US realm has now replaced meaningful use common data elements with [USCDI](https://www.healthit.gov/isa/united-states-core-data-interoperability-uscdi).

          This test currently uses `meta.profile` to validate that a resource is compliant with its intended profile,
          which includes checking for the profile's required elements.

          It is the servers responsiblity to return all resources necessary to cover all USDCI elements known by
          the server.
        MARKDOWN
        uses_request :patient_everything

        run do
          skip_if resource.resourceType != 'Bundle'

          (0...resource.entry.length).each do |i|
            assert_valid_resource(resource: resource.entry[i].resource,
                                  profile_url: resource.entry[i].resource.meta.profile)
          end
        end
      end

      test do
        title <<~PLAIN_TEXT
          Attestation: Server returns all resources necessary to cover all USDCI elements known by the server if
          operating in US Realm.
        PLAIN_TEXT
        description 'See previous test for details.'
        input :uscdi_attestation,
              title: <<~PLAIN_TEXT
                Server returns all resources necessary to cover all USDCI elements known by the server if
                operating in US Realm.
              PLAIN_TEXT,
              type: :radio,
              options: {
                list_options: [
                  {
                    label: 'Yes',
                    value: 'yes'
                  },
                  {
                    label: 'No',
                    value: 'no'
                  }
                ]
              },
              default: 'no'

        run do
          assert uscdi_attestation == 'yes', 'Developer did not agree to attestation'
        end
      end

      test do
        title <<~PLAIN_TEXT
          Attestation: The use of the Bulk FHIR specification for transmission of member $everything data SHALL
          honor jurisdictional and personal privacy restrictions that are relevant to a member’s health record.
        PLAIN_TEXT
        input :privacy_attestation,
              title: %Q(
                Server shall honor jurisdictional and personal privacy restriction that are relevant to a
                member's health record for $everything
              ),
              type: :radio,
              options: {
                list_options: [
                  {
                    label: 'Yes',
                    value: 'yes'
                  },
                  {
                    label: 'No',
                    value: 'no'
                  }
                ]
              },
              default: 'no'

        run do
          assert privacy_attestation == 'yes', 'Developer did not agree to attestation'
        end
      end

      # TODO: consider parameter tests
    end
  end
end
