# frozen_string_literal: true
require_relative 'member_match_request_profile_validation'
require_relative 'member_match_request_local_references_validation'
require_relative 'coverage_to_link_minimal_data_validation'
require_relative 'coverage_to_link_must_support_validation'

module DaVinciPDexTestKit
  module PDexPayerServer
    class NoMemberMatchesGroup < Inferno::TestGroup
        id :pdex_no_member_matches
        title '$member-match with no matches'

        run_as_group

        input :no_member_match_request,
          title: 'Member Match Request for no matches',
          description: "A JSON payload for server's $member-match endpoint that has **no matches**",
          type: 'textarea',
          optional: true

        group_config = { inputs: { member_match_request: { name: :no_member_match_request } } }

        test from: :pdex_member_match_profile_validation do
          id :pdex_no_member_match_profile
          config(group_config)

          title '[USER INPUT VALIDATION] Member match request for no matches is valid'
          description %{
            Regardless of having no intended matches, this test validates the conformity of the user input to the
            [HRex Member Match Request Profile](https://hl7.org/fhir/us/davinci-hrex/STU1/StructureDefinition-hrex-parameters-member-match-in.html),
            ensuring subsequent tests can accurately simulate content. It also checks conformance to the [Parameters Resource](https://hl7.org/fhir/R4/parameters.html),
            mandatory elements, and terminology. It also checks that the Patient reference with the Consent and CoverageToMatch parameters are local references.
          }
        end

        test from: :pdex_member_match_local_ref_validation, config: group_config

        test from: :pdex_coverage_to_link_minimal_validation, config: group_config
        test from: :pdex_coverage_to_link_ms_validation, config: group_config


        test do
          id :pdex_member_match_has_no_matches
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
