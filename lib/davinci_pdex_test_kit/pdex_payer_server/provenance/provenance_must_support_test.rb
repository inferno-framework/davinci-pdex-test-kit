require 'us_core_test_kit/must_support_test'
require 'us_core_test_kit/generator/group_metadata'

module DaVinciPDexTestKit
  module PDexPayerServer
    class ProvenanceMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Provenance resources returned'
      description %(
        PDex Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the PDex Server Capability
        Statement. This test will look through the Provenance resources
        found previously for the following must support elements:

        * Provenance.agent
        * Provenance.agent.onBehalfOf
        * Provenance.agent.type
        * Provenance.agent.who
        * Provenance.agent:ProvenanceAuthor
        * Provenance.agent:ProvenanceAuthor.type
        * Provenance.agent:ProvenanceAuthor.who
        * Provenance.agent:ProvenanceTransmitter
        * Provenance.agent:ProvenanceTransmitter.type
        * Provenance.agent:ProvenanceTransmitter.who
        * Provenance.entity.extension:sourceFormat
        * Provenance.recorded
        * Provenance.target
      )

      id :pdex_provenance_must_support

      def resource_type
        'Provenance'
      end

      def self.metadata
        @metadata ||= USCoreTestKit::Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'),
                                                                                 aliases: true))
      end

      def scratch_resources
        scratch[:provenance_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
