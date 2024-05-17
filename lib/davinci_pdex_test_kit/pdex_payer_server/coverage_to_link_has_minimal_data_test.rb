
module DaVinciPDexTestKit
  module PDexPayerServer
    class CoverageToLinkHasMinimalDataTest < Inferno::Test

      id :coverage_to_link_has_minimal_data
      title 'CoverageToLink parameter should not include any data elements not marked as mustSupport'
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
                "No CoverageToLink parameter provided"

        coverage = member_match_request_resource.parameter.find{|p| p.name=='CoverageToLink'}.resource

        assert_resource_type(:coverage, resource: coverage)
        assert !coverage.type
        assert !coverage.policyHolder
        assert !coverage.subscriber
        assert !coverage.relationship
        assert !coverage.period
        assert !coverage.local_class.any? do |backbone_element|
          backbone_element.type.coding.any? do |coding|
            !(coding.code == 'group' && 
              coding.system == 'http://terminology.hl7.org/CodeSystem/coverage-class')
          end
        end
        assert !coverage.order
        assert !coverage.network
        assert coverage.costToBeneficiary.empty?
        assert coverage.subrogation.nil?
        assert !coverage.contract
      end

    end
  end
end
