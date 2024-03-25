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


    end
  end
  
