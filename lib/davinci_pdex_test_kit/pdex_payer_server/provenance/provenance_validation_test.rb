require 'us_core_test_kit/validation_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class ProvenanceValidationTest < Inferno::Test
      include USCoreTestKit::ValidationTest

      id :pdex_provenance_validation_test
      title 'Provenance resources returned during previous tests conform to the PDex Provenance'
      description %(
        This test verifies resources returned from the first search conform to
        the [PDex Provenance](http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provenance).
        Systems must demonstrate at least one valid example in order to pass this test.

        It verifies the presence of mandatory elements and that elements with
        required bindings contain appropriate values. CodeableConcept element
        bindings will fail if none of their codings have a code/system belonging
        to the bound ValueSet. Quantity, Coding, and code element bindings will
        fail if their code/system are not found in the valueset.
      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'Provenance'
      end

      def scratch_resources
        scratch[:provenance_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-provenance',
                                '2.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
