# Uncomment to require all of US Core
# require 'us_core_test_kit'

# Uncomment to import US Core v3.1.1, TLS, SMART STU1, and SMART STU2 Test Suites
# require 'us_core_test_kit/generated/v3.1.1/us_core_test_suite'

require 'us_core_test_kit/generator'

## TODO - remove below when done
require 'debug'

## MoneyPatch
module USCoreTestKit
  class Generator
    class IGMetadataExtractor

      def add_missing_supported_profiles
        case ig_resources.ig.ig_version
        when '2.0.0'
          # The Da Vinci PDex 2.0.0 Capability Statement lists US Core 3.1.1 profiles without having
          # their StructureDefinitions in its package
          # TODO: merge ig_resources with IGLoader.new('us_core_3.1.1.tgz').load
        when '3.1.1'
          # The US Core v3.1.1 Server Capability Statement does not list support for the
          # required vital signs profiles, so they need to be added
          ig_resources.capability_statement.rest.first.resource
            .find { |resource| resource.type == 'Observation' }
            .supportedProfile.concat [
              'http://hl7.org/fhir/StructureDefinition/bodyheight',
              'http://hl7.org/fhir/StructureDefinition/bodytemp',
              'http://hl7.org/fhir/StructureDefinition/bp',
              'http://hl7.org/fhir/StructureDefinition/bodyweight',
              'http://hl7.org/fhir/StructureDefinition/heartrate',
              'http://hl7.org/fhir/StructureDefinition/resprate'
            ]
        when '5.0.1'
          # The US Core v5.0.1 Server Capability Statement does not have supported-profile for Encounter
          ig_resources.capability_statement.rest.first.resource
            .find { |resource| resource.type == 'Encounter' }
            .supportedProfile.concat [
              'http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter'
            ]
        end
      end

      def add_metadata_from_resources
        metadata.groups =
          resources_in_capability_statement.flat_map do |resource|
            resource.supportedProfile&.map do |supported_profile|
              # binding.break # XXX
            
              GroupMetadataExtractor.new(resource, supported_profile, metadata, ig_resources).group_metadata
            end
          end
      end
    end

    class GroupMetadataExtractor
      def class_name
        base_name
          .split('-')
          .map(&:capitalize)
          .join
          .gsub('UsCore', "USCore#{ig_metadata.reformatted_version}")
          .concat('Sequence')
      end

      def profile_name
        binding.break
        profile.title.gsub('  ', ' ')
      end
    end

    class IGResources

      # TODO have this load PDex 2.0 and US Core 3.1.1
    

      # TODO remove - this function is for debugging
      def keys
        @resources_by_type&.keys
      end
    end
  end
end

module DaVinciPDexTestKit

  class Generator < USCoreTestKit::Generator

    def self.generate()
      ig_package = File.join(__dir__, 'igs', 'davinci-pdex-2.0.0.tgz')
      new(ig_package).generate
    end

    def initialize(ig_file_name)
      super(ig_file_name)
    end

    def base_output_dir
      # super's return:
      # File.join(__dir__, 'generated', ig_metadata.ig_version)
      File.join(__dir__, 'generated', 'pdex_payer_server')
    end

    def generate
      puts "Generating tests for IG #{File.basename(ig_file_name)}"
      load_ig_package
      extract_metadata
      generate_search_tests
      generate_read_tests

      # TODO: generate_vread_tests
      # TODO: generate_history_tests

      generate_provenance_revinclude_search_tests
      generate_validation_tests
      generate_must_support_tests
      generate_reference_resolution_tests

      # generate_granular_scope_tests

      generate_groups

      # generate_granular_scope_resource_type_groups

      # generate_granular_scope_groups

      generate_suites

      write_metadata
    end

  end

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
      title 'Patient $everything'
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
              rest_metadata.resource.select{ |resource_metadata| resource_metadata.type == 'Patient' }.first.
                operation.any? do |operation_metadata|
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
          assert resource.entry.map(&:resource).map(&:resourceType).any?('Patient'), 'Bundle does not include a Patient resource'
          assert resource.entry.map(&:resource).one? { |resource| resource.resourceType == 'Patient' && resource.id == patient_id }            
        end
      end

      test do
        title 'The resources returned SHALL include all the data covered by the meaningful use common data elements as defined in the US Core Implementation Guide'
        description <<~MARKDOWN
          See FHIR R4 documentation for [patient-everything](https://hl7.org/fhir/R4/patient-operation-everything.html). The US realm has now replaced meaningful use common
          data elements with [USCDI](https://www.healthit.gov/isa/united-states-core-data-interoperability-uscdi).

          This test currently uses `meta.profile` to validate that a resource is compliant with its intended profile, which includes checking for the profile's
          required elements.

          It is the servers responsiblity to return all resources necessary to cover all USDCI elements known by the server.
        MARKDOWN
        uses_request :patient_everything

        US_CORE_PROFILES = {
          'AllergyIntolerance' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance',
          'CarePlan' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan',
          'CareTeam' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam',
          'Condition' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition',
          'DiagnosticReport' => [
            'https://www.hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab',
            'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note'
          ],
          'DocumentReference' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference',
          'Encounter' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter',
          'Goal' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal',
          'Immunization' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization',
          'Device' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device', # ImplantableDevice
          'Location' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-location',
          'Medication' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication',
          'MedicationRequest' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest',
          'Organization' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization',
          'Patient' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient',
          'Observation' => [
            'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab',     # Laboratory Result Observation
            'http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age',       # Pediatric BMI for Age
            'http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height', # Pediatric Weight for Height
            'http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry',      # Pulse Oximetry
            'http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus'        # Smoking Status Observation
          ],
          'Practitioner' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner',
          'PractitionerRole' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole',
          'Procedure' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure'
        }

        run do
          skip_if resource.resourceType != 'Bundle'

          # XXX
          # require 'debug/open_nonstop'
          # debugger

          (0...resource.entry.length).each do |i|
            assert_valid_resource(resource: resource.entry[i].resource, profile_url: resource.entry[i].resource.meta.profile)
          end
        end
      end

      test do
        title 'Attestation: Server returns all resources necessary to cover all USDCI elements known by the server if operating in US Realm.'
        description 'See previous test for details.'
        input :uscdi_attestation,
              title: 'Server returns all resources necessary to cover all USDCI elements known by the server if operating in US Realm.',
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
        title "Attestation: The use of the Bulk FHIR specification for transmission of member $everything data SHALL honor jurisdictional and personal privacy restrictions that are relevant to a member’s health record."
        input :privacy_attestation,
              title: "Server shall honor jurisdictional and personal privacy restriction that are relevant to a member's health record for $everything",
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

      # TODO consider $everything parameter tests

    end
  end

end
