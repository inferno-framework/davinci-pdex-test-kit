require 'us_core_test_kit/generator/group_metadata'
require_relative 'explanation_of_benefit/explanation_of_benefit_patient_use_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_id_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_patient_last_updated_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_patient_service_date_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_patient_type_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_identifier_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_read_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_provenance_revinclude_search_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_validation_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_must_support_test'
require_relative 'explanation_of_benefit/explanation_of_benefit_reference_resolution_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    # PDex PriorAuthorization Profile for ExplanationOfBenefit Resource Test Group
    class ExplanationOfBenefitGroup < Inferno::TestGroup
      id :pdex_eob
      title 'PDex Prior Authorization Tests'
      short_description 'Verify support for the server capabilities required by the PDex Prior Authorization Profile.'
      description %(
# Background

The PDex Prior Authorization sequence verifies that the system under test is
able to provide correct responses for ExplanationOfBenefit queries. These queries
must contain resources conforming to the PDex Prior Authorization Profile as
specified in the Da Vinci PDex v2.0.0 Implementation Guide.

# Testing Methodology
## Searching
This test sequence will first perform each required search associated
with this resource. This sequence will perform searches with the
following parameters:

* patient + use
* _id
* patient + _lastUpdated
* patient + service-date
* patient + type
* identifier

### Search Parameters
The first search uses the selected patient(s) from the Patient Tests group.
Any subsequent searches will look for its parameter values
from the results of the first search. For example, the `provider`
search in this sequence is performed by looking for an existing
`ExplanationOfBenefit.provider` from any of the resources returned in the `patient`
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
the [PDex Prior Authorization Profile](http://hl7.org/fhir/us/davinci-pdex/StructureDefinition-pdex-priorauthorization.html).
Each element is checked against teminology binding and cardinality requirements.

Elements with a required binding are validated against their bound
ValueSet. If the code/system in the element is not part of the ValueSet,
then the test will fail.

## Reference Validation
At least one instance of each external reference in elements marked as
"must support" within the resources provided by the system must resolve.
The test will attempt to read each reference found and will fail if no
read succeeds.
      )

      run_as_group

      def self.metadata
        # TODO: create metadata.yml to fit GroupMetadata OR circumvent metadata
        @metadata ||= USCoreTestKit::Generator::GroupMetadata.new(
          YAML.load_file(File.join(__dir__, 'explanation_of_benefit', 'metadata.yml')), aliases: true
        )
      end

      test from: :pdex_eob_patient_use_search
      test from: :pdex_eob_id_search
      test from: :pdex_eob_patient_last_updated_search
      test from: :pdex_eob_patient_service_date_search
      test from: :pdex_eob_patient_type_search
      test from: :pdex_eob_identifier_search
      test from: :pdex_eob_read
      test from: :pdex_eob_provenance_revinclude_search
      test from: :pdex_eob_validation
      test from: :pdex_eob_must_support
      # test from: :pdex_eob_ref_resolution
    end
  end
end
