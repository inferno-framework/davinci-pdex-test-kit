
module DaVinciPDexTestKit
  module PDexPayerServer

    # Factorized test for Member Match Request CoverageToLink parameter validation on PDex v2.0.0 and HRex v1.0.0.
    #
    # See Documentation for CoverageToLink parameter at
    # https://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html#membermatch
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
    # Fails if no CoverageToLink parameter provided.
    #
    class CoverageToLinkMustSupportValidation < Inferno::Test

      id :pdex_coverage_to_link_must_support_validation
      title '[USER INPUT VALIDATION] CoverageToLink parameter is optional for generic FHIR clients, but required for Payer systems.'
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
