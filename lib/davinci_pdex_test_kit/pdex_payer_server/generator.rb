require 'fhir_models'
require 'inferno/ext/fhir_models'

require_relative 'generator/ig_loader'
require_relative 'generator/ig_metadata_extractor'
# require_relative 'generator/granular_scope_group_generator'
# require_relative 'generator/granular_scope_resource_type_group_generator'
# require_relative 'generator/granular_scope_test_generator'
require_relative 'generator/group_generator'
require_relative 'generator/must_support_test_generator'
require_relative 'generator/provenance_revinclude_search_test_generator'
require_relative 'generator/read_test_generator'
require_relative 'generator/reference_resolution_test_generator'
require_relative 'generator/search_test_generator'
require_relative 'generator/suite_generator'
require_relative 'generator/validation_test_generator'

module DaVinciPDexTestKit
  module PDexPayerServer

    class Generator

      HREX_IG = File.join(__dir__, '..', 'igs', 'davinci-hrex-1.0.0.tgz')
      PDEX_IG = File.join(__dir__, '..', 'igs', 'davinci-pdex-2.0.0.tgz')
      US_CORE_V311_IG = File.join(__dir__, '..', 'igs', 'us-core-3.1.1.tgz')


      def self.generate
        # XXX Should only contain PDex and HRex
        # ig_packages = Dir.glob(File.join(Dir.pwd, 'lib', 'davinci_pdex_test_kit', 'igs', '*.tgz'))
        #
        # ig_packages.each do |ig_package|
        #   new(ig_package).generate
        # end

        new(PDEX_IG).generate
      end

      attr_accessor :ig_resources, :ig_metadata, :ig_file_name

      def initialize(ig_file_name)
        self.ig_file_name = ig_file_name
      end

      def generate
        puts "Generating tests for IG #{File.basename(ig_file_name)}"

        # Load primary PDex IG
        load_ig_package PDEX_IG

        # Load PDex depenencies from HRex and USCore
        load_ig_package US_CORE_V311_IG
        load_ig_package HREX_IG

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

      def extract_metadata
        self.ig_metadata = IGMetadataExtractor.new(ig_resources).extract

        FileUtils.mkdir_p(base_output_dir)
      end

      def write_metadata
        File.open(File.join(base_output_dir, 'metadata.yml'), 'w') do |file|
          file.write(YAML.dump(ig_metadata.to_hash))
        end
      end

      def base_output_dir
        File.join(__dir__, 'generated', ig_metadata.ig_version)
      end

      def load_ig_package(ig_path)
        FHIR.logger = Logger.new('/dev/null')
        self.ig_resources = IGLoader.new(ig_path, self.ig_resources).load

        # XXX
        # require 'debug/open_nonstop'
        # debugger
      end

      def generate_reference_resolution_tests
        ReferenceResolutionTestGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_must_support_tests
        MustSupportTestGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_validation_tests
        ValidationTestGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_read_tests
        ReadTestGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_search_tests
        SearchTestGenerator.generate(ig_metadata, base_output_dir)
      end

      def generate_provenance_revinclude_search_tests
        ProvenanceRevincludeSearchTestGenerator.generate(ig_metadata, base_output_dir)
      end

      # def generate_granular_scope_tests
      #   GranularScopeTestGenerator.generate(ig_metadata, base_output_dir)
      # end

      def generate_groups
        GroupGenerator.generate(ig_metadata, base_output_dir)
      end

      # def generate_granular_scope_resource_type_groups
      #   GranularScopeResourceTypeGroupGenerator.generate(ig_metadata, base_output_dir)
      # end

      # def generate_granular_scope_groups
      #   GranularScopeGroupGenerator.generate(ig_metadata, base_output_dir)
      # end

      def generate_suites
        SuiteGenerator.generate(ig_metadata, base_output_dir)
      end
    end

  end
end
