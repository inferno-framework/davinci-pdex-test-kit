
module DaVinciPDexTestKit
  module PDexPayerServer

    # Factorized test for Member Match Request CoverageToLink parameter validation on PDex v2.0.0 and HRex v1.0.0.
    #
    # See https://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html#notes.
    #
    # ==== Inputs
    #
    # +member_match_request+ - Parameters FHIR resource JSON text with CoverageToLink parameter
    #
    # ==== Outputs
    #
    # (none)
    #
    # ==== Required Config
    #
    # (none)
    #
    # ==== Required Scratch
    #
    # (none)
    #
    # ==== Notes
    #
    # Skips if no CoverageToLink parameter provided.
    #
    class CoverageToLinkMinimalDataValidation < Inferno::Test

      id :pdex_coverage_to_link_minimal_validation
      title '[USER INPUT VALIDATION] CoverageToLink parameter should not include any data elements not marked as mustSupport'
      optional
      description %{
        This test will skip if there is no CoverageToLink parameter in the member match request input for one match.

        If that resource is present, it will check conformance against the
        [HRex Coverage Profile](https://hl7.org/fhir/us/davinci-hrex/STU1/StructureDefinition-hrex-coverage.html)
        and check that no elements that are neither MustSupport nor Mandatory are present.

        If certain MustSupport elements are missing this test may still pass.

        See [notes](https://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html#notes) in HRex Implementation Guide,
        as required by PDex Implementation Guide.
      }

      input :member_match_request

      run do
        member_match_request_resource = FHIR.from_contents(member_match_request)
        skip_if !member_match_request_resource.parameter.find{|p| p.name=='CoverageToLink'},
                'No CoverageToLink parameter provided'

        coverage = member_match_request_resource.parameter.find{|p| p.name=='CoverageToLink'}.resource

        assert_resource_type(:coverage, resource: coverage)
        assert !coverage.type, 'CoverageToLink parameter has unnecessary type field'
        assert !coverage.policyHolder, 'CoverageToLink parameter has unnecessary policyHolder field'
        assert !coverage.subscriber, 'CoverageToLink parameter has unnecessary subscriber field'
        assert !coverage.relationship, 'CoverageToLink parameter has unnecessary relationship field'
        assert !coverage.period, 'CoverageToLink parameter has unnecessary period field'
        extraneous_coverage_classes = coverage.local_class.any? do |backbone_element|
          backbone_element.type.coding.any? do |coding|
            !(coding.code == 'group' && 
              coding.system == 'http://terminology.hl7.org/CodeSystem/coverage-class')
          end
        end
        assert !extraneous_coverage_classes, 'CoverageToLink parameter has class field with array elements aside from the group slice'
        assert !coverage.order, 'CoverageToLink parameter has unnecessary order field'
        assert !coverage.network, 'CoverageToLink parameter has unecessary network field'
        assert coverage.costToBeneficiary.nil? || coverage.costToBeneficiary.empty?, 'CoverageToLink parameter has unnecessary costToBeneficiary field'
        assert coverage.subrogation.nil?, 'CoverageToLink parameter has unnecessary subrogation field'
        assert coverage.contract.nil? || coverage.contract.empty?, 'CoverageToLink parameter has uncessary contract field'
      end

    end
  end
end
