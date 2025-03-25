require_relative 'medication_dispense/medication_dispense_patient_search_test'
require_relative 'medication_dispense/medication_dispense_read_test'
require_relative 'medication_dispense/medication_dispense_patient_status_search_test'
require_relative 'medication_dispense/medication_dispense_patient_status_type_search_test'
require_relative 'medication_dispense/medication_dispense_provenance_revinclude_search_test'
require_relative 'medication_dispense/medication_dispense_validation_test'
require_relative 'medication_dispense/medication_dispense_must_support_test'
require_relative 'medication_dispense/medication_dispense_reference_resolution_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class MedicationDispenseGroup < Inferno::TestGroup
      title 'PDex MedicationDispense Tests'
      short_description 'Verify support for the server capabilities required by the PDex MedicationDispense.'
      description %(
        # Background

        The PDex MedicationDispense sequence verifies that the system under test is
        able to provide correct responses for MedicationDispense queries. These queries
        must contain resources conforming to the PDex MedicationDispense as
        specified in the PDex v2.0.0 Implementation Guide.

        # Testing Methodology


        ## Must Support
        Each profile contains elements marked as "must support". This test
        sequence expects to see each of these elements at least once. If at
        least one cannot be found, the test will fail. The test will look
        through the MedicationDispense resources found in the first test for these
        elements.

        ## Profile Validation
        Each resource returned from the first search is expected to conform to
        the [PDex MedicationDispense](http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-medicationdispense). Each element is checked against
        teminology binding and cardinality requirements.

        Elements with a required binding are validated against their bound
        ValueSet. If the code/system in the element is not part of the ValueSet,
        then the test will fail.

        ## Reference Validation
        At least one instance of each external reference in elements marked as
        "must support" within the resources provided by the system must resolve.
        The test will attempt to read each reference found and will fail if no
        read succeeds.
      )

      id :pdex_medication_dispense
      run_as_group

      def self.metadata
        @metadata ||= USCoreTestKit::USCoreTestKit::Generator::GroupMetadata.new(YAML.load_file(
                                                                                   File.join(__dir__, 'medication_dispense',
                                                                                             'metadata.yml'), aliases: true
                                                                                 ))
      end

      test from: :pdex_medication_dispense_patient_search_test
      test from: :pdex_medication_dispense_patient_status_search_test
      test from: :pdex_medication_dispense_patient_status_type_search_test
      test from: :pdex_medication_dispense_read_test
      test from: :pdex_medication_dispense_provenance_revinclude_search_test
      test from: :pdex_medication_dispense_validation_test
      test from: :pdex_medication_dispense_must_support_test
      test from: :pdex_medication_dispense_reference_resolution_test
    end
  end
end
