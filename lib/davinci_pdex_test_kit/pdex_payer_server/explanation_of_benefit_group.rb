require_relative 'explanation_of_benefit/explanation_of_benefit_patient_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_id_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_patient_lastupdated_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_patient_type_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_identifier_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_patient_service_date_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_read_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_validation_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_must_support_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_reference_resolution_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class ExplanationOfBenefitGroup < Inferno::TestGroup
      title 'PDex Prior Authorization Tests'
      short_description 'Verify support for the server capabilities required by the PDex Prior Authorization.'
      description %(
        # Background

        The PDex Prior Authorization sequence verifies that the system under test is
        able to provide correct responses for ExplanationOfBenefit queries. These queries
        must contain resources conforming to the PDex Prior Authorization as
        specified in the PDex v2.0.0 Implementation Guide.

        # Testing Methodology
        ## Searching
        This test sequence will first perform each required search associated
        with this resource. This sequence will perform searches with the
        following parameters:

        * patient
        * _id
        * patient + _lastUpdated
        * patient + type
        * identifier
        * patient + service-date

        ### Search Parameters
        The first search uses the selected patient(s) from the prior launch
        sequence. Any subsequent searches will look for its parameter values
        from the results of the first search. For example, the `identifier`
        search in the patient sequence is performed by looking for an existing
        `Patient.identifier` from any of the resources returned in the `_id`
        search. If a value cannot be found this way, the search is skipped.

        ### Search Validation
        Inferno will retrieve up to the first 20 bundle pages of the reply for
        ExplanationOfBenefit resources and save them for subsequent tests. Each of
        these resources is then checked to see if it matches the searched
        parameters in accordance with [FHIR search
        guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
        for example, if a Patient search for `gender=male` returns a `female`
        patient.


        ## Must Support
        Each profile contains elements marked as "must support". This test
        sequence expects to see each of these elements at least once. If at
        least one cannot be found, the test will fail. The test will look
        through the ExplanationOfBenefit resources found in the first test for these
        elements.

        ## Profile Validation
        Each resource returned from the first search is expected to conform to
        the [PDex Prior Authorization](http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-priorauthorization). Each element is checked against
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

      id :pdex_eob
      run_as_group

      def self.metadata
        @metadata ||= USCoreTestKit::USCoreTestKit::Generator::GroupMetadata.new(YAML.load_file(
                                                                                   File.join(__dir__, 'explanation_of_benefit',
                                                                                             'metadata.yml'), aliases: true
                                                                                 ))
      end

      test from: :pdex_eob_patient_search_test
      test from: :pdex_eob_id_search_test
      test from: :pdex_eob_patient_lastUpdated_search_test
      test from: :pdex_eob_patient_type_search_test
      test from: :pdex_eob_identifier_search_test
      test from: :pdex_eob_patient_service_date_search_test
      test from: :pdex_eob_read_test
      test from: :pdex_eob_validation_test
      test from: :pdex_eob_must_support_test
      test from: :pdex_eob_reference_resolution_test
    end
  end
end
