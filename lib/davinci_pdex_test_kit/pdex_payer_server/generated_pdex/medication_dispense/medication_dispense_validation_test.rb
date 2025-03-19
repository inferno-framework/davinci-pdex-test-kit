require_relative '../../../validation_test'

module USCoreTestKit
  module USCoreV200
    class MedicationDispenseValidationTest < Inferno::Test
      include USCoreTestKit::ValidationTest

      id :us_core_v200_medication_dispense_validation_test
      title 'MedicationDispense resources returned during previous tests conform to the PDex MedicationDispense'
      description %(
This test verifies resources returned from the first search conform to
the [PDex MedicationDispense](http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-medicationdispense).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'MedicationDispense'
      end

      def scratch_resources
        scratch[:medication_dispense_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-medicationdispense',
                                '2.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
