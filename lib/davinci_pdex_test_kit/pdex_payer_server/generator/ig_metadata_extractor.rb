require_relative 'ig_metadata'
require_relative 'group_metadata_extractor'

module DaVinciPDexTestKit
  module PDexPayerServer
  class Generator
    class IGMetadataExtractor
      attr_accessor :ig_resources, :metadata

      def initialize(ig_resources)
        self.ig_resources = ig_resources
        remove_version_from_supported_profiles
        remove_extra_supported_profiles
        self.metadata = IGMetadata.new
      end

      def extract
        add_metadata_from_ig
        add_metadata_from_resources
        metadata
      end

      def add_metadata_from_ig
        metadata.ig_version = "v#{ig_resources.ig.version}"
      end

      def resources_in_capability_statement
        ig_resources.capability_statement.rest.first.resource
      end

      def remove_version_from_supported_profiles
        resources_in_capability_statement.each do |resource|
          resource.supportedProfile.map! { |profile_url| profile_url.split('|').first }
        end
      end

      def remove_extra_supported_profiles
        ig_resources.capability_statement.rest.first.resource
            .find { |resource| resource.type == 'Observation' }
            .supportedProfile.delete_if do |profile_url|
              SpecialCases::PROFILES_TO_EXCLUDE.include?(profile_url)
            end
      end

      def remove_us_core_supported_profiles        
        ig_resources.capability_statement.rest.first.resource
            .find { |resource| resource.type == 'Observation' }
            .supportedProfile.delete_if do |profile_url|
              profile_url.include?('us-core') ||
              profile_url.include?('/us/core') ||
              profile_url == 'http://hl7.org/fhir/StructureDefinition/vitalsigns'
            end
      end

      def add_metadata_from_resources
        metadata.groups =
          resources_in_capability_statement.flat_map do |resource|

            resource.supportedProfile&.map do |supported_profile|
              #supported_profile = supported_profile.split('|').first
              next if supported_profile == 'http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire'

              # TODO: skip US Core profiles

              GroupMetadataExtractor.new(resource, supported_profile, metadata, ig_resources).group_metadata
            end
          end.compact

        metadata.postprocess_groups(ig_resources)
      end
    end
  end
  end
end
