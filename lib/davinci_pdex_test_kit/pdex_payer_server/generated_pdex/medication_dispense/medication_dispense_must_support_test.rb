require_relative '../../../must_support_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class MedicationDispenseMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the MedicationDispense resources returned'
      description %(
        PDex Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the PDex Server Capability
        Statement. This test will look through the MedicationDispense resources
        found previously for the following must support elements:

        * MedicationDispense.status
        * MedicationDispense.subject
        * MedicationDispense.substitution
        * MedicationDispense.substitution.wasSubstituted
      )

      id :pdex_medication_dispense_must_support_test

      def resource_type
        'MedicationDispense'
      end

      def self.metadata
        @metadata ||= USCoreTestKit::Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'),
                                                                                 aliases: true))
      end

      def scratch_resources
        scratch[:medication_dispense_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
