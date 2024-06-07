# frozen_string_literal: true
require_relative 'abstract_member_match_request_conformance_test'
require_relative 'abstract_member_match_request_local_references_test'
require_relative 'coverage_to_link_has_minimal_data_test'
require_relative 'coverage_to_link_must_support_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class NoMemberMatchesGroup < Inferno::TestGroup
        id :no_member_matches_group
        title '$member-match with no matches'

        run_as_group

        input :no_member_match_request,
          title: 'Member Match Request for no matches',
          description: "A JSON payload for server's $member-match endpoint that has **no matches**",
          type: 'textarea',
          optional: true

        group_config = { inputs: { member_match_request: { name: :no_member_match_request } } }

        test from: :abstract_member_match_request_conformance do
          id :no_member_match_request_conformance
          config(group_config)

          title '[USER INPUT VALIDATION] Member match request for no matches is valid'
          description %{
            Regardless of having no intended matches, this test validates the conformity of the user input to the
            [HRex Member Match Request Profile](https://hl7.org/fhir/us/davinci-hrex/STU1/StructureDefinition-hrex-parameters-member-match-in.html),
            ensuring subsequent tests can accurately simulate content. It also checks conformance to the [Parameters Resource](https://hl7.org/fhir/R4/parameters.html),
            mandatory elements, and terminology. It also checks that the Patient reference with the Consent and CoverageToMatch parameters are local references.
          }

          # Inherits run
        end

        test from: :abstract_member_match_request_local_references do
          id :no_member_match_request_local_references
          config(group_config)
        end

        test from: :coverage_to_link_has_minimal_data, config: group_config
        test from: :coverage_to_link_must_support, config: group_config


        test do
          id :member_match_has_no_matches
          title 'Server $member-match operation returns 422 Unprocessable Content if no matches are found'
          description %{
            See [member matching logic](https://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html#member-matching-logic)
            for specification.

            Server will receive `POST [baseURL]/Patient/$member-match` with the no-member-match-request parameters and
            is expected to return 422.
          }

          run do
            skip_if !no_member_match_request, "No member match request inputted for no-match tests."
            member_match_request_resource = FHIR.from_contents(no_member_match_request)

            fhir_operation('/Patient/$member-match', body: member_match_request_resource)
            assert_response_status(422)
          end
        end

    end
  end
end
