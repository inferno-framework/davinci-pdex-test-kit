# frozen_string_literal: true
require_relative 'abstract_member_match_request_conformance_test'
require_relative 'abstract_member_match_request_local_references_test'
require_relative 'coverage_to_link_has_minimal_data_test'
require_relative 'coverage_to_link_must_support_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class MultipleMemberMatchesGroup < Inferno::TestGroup

        id :multiple_member_matches_group
        title '$member-match with multiple matches'

        run_as_group

        # TODO: preset or default
        input :multiple_member_match_request,
          title: 'Member Match Request for multiple matches',
          description: "A JSON payload for server's $member-match endpoint that has **more than one match**",
          type: 'textarea',
          optional: true

        group_config = { inputs: { member_match_request: { name: :multiple_member_match_request } } }
  
        test from: :abstract_member_match_request_conformance do
          id :multiple_member_match_request_conformance
          config(group_config)
          title '[USER INPUT VALIDATION] Member match request for multiple matches is valid'
          description %{
            This test validates the conformity of the user input to the
            [HRex Member Match Request Profile](https://hl7.org/fhir/us/davinci-hrex/STU1/StructureDefinition-hrex-parameters-member-match-in.html),
            ensuring subsequent tests can accurately simulate content. It also checks conformance to the [Parameters Resource](https://hl7.org/fhir/R4/parameters.html),
            mandatory elements, and terminology. It also checks that the Patient reference with the Consent and CoverageToMatch parameters are local references.
          }

          # Inherits
        end

        test from: :abstract_member_match_request_local_references do
          id :multiple_member_match_request_local_references
          config(group_config)
        end
  
        test do
          id :member_match_has_multiple_matches
          title 'Server $member-match operation returns 422 Unprocessable Content if multiple matches are found'
          description %{
            See [member matching logic](https://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html#member-matching-logic)
            for specification.
          }
  
          run do
            skip_if !multiple_member_match_request, "No member match request inputted for multiple-match tests."

            member_match_request_resource = FHIR.from_contents(multiple_member_match_request)
  
            fhir_operation('/Patient/$member-match', body: member_match_request_resource)
            assert_response_status(422)
          end
        end

        test from: :coverage_to_link_has_minimal_data, config: group_config
        test from: :coverage_to_link_must_support, config: group_config

    end
  end
end