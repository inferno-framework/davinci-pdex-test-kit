
module DaVinciPDexTestKit
  module PDexPayerServer
    class CoverageToLinkMustSupportTest < Inferno::Test

      id :coverage_to_link_must_support
      title 'CoverageToLink parameter is optional for generic FHIR clients, but required for Payer systems.'
      description 'See [CoverageToLink parameter documentation](https://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html).'
      optional

      input :member_match_request

      # Special test for 'CoverageToLink' test in Member Match Request, which is "MustSupport":
      # https://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html
      #
      # > This parameter is optional as this operation may be invoked by non-payer systems. However, it is considered 'mustSupport'.
      # > If the client invoking the operation is a payer, they SHALL include their coverage information for the member when invoking
      # > the operation.
      run do
        member_match_request_resource = FHIR.from_contents(member_match_request)

        assert member_match_request_resource.parameter.find{|p| p.name=='CoverageToLink'}&.resource, "No CoverageToLink parameter provided."
        assert_resource_type(:coverage, resource: member_match_request_resource.parameter.find{|p| p.name=='CoverageToLink'}&.resource)
      end

    end
  end
end
