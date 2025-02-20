# frozen_string_literal: true
require_relative 'member_match_request_profile_validation'
require_relative 'member_match_request_local_references_validation'
require_relative 'coverage_to_link_minimal_data_validation'
require_relative 'coverage_to_link_must_support_validation'

require_relative 'patient_operation_in_capability_statement_validation'

module DaVinciPDexTestKit
  module PDexPayerServer
    class WorkflowMemberMatchGroup < Inferno::TestGroup
      title 'Server can return a matching member in response to $member-match request'
      short_title '$member-match'
      id :pdex_workflow_member_match
      description %{
        # Background

        Server must implement the [$member-match operation](https://hl7.org/fhir/us/davinci-hrex/OperationDefinition-member-match.html)
        for payer-to-payer workflows as
        [required by the PDex Implementation Guide](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#member-match-with-consent).

        # Testing Methodology
        
        The developer must supply JSON FHIR input parameter conforming to the
        [member match request profile](https://hl7.org/fhir/us/davinci-hrex/STU1/StructureDefinition-hrex-parameters-member-match-in.html). This
        test sequence will:
        
        1. Request the server's capability statement and verify that it asserts support for the $member-match operation
        2. Validate user's member match request input
           + validate Parameters profile conformance
           + validate references as local references
           + optional: validate CoverageToLink parameter
           + optional: validate minimal data on CoverageToLink parameter
        3. POST request to server and validate HTTP 200 response status
        4. validate memeber match response conforms to profile
        5. use member identifier from response to query for patient id 
      }

      run_as_group

      input :member_match_request,
        title: 'Member Match Request for one match',
        description: "A JSON payload for server's $member-match endpoint that has **exactly one match**",
        type: 'textarea'

      test from: :pdex_patient_operation_in_cap_stmt_validation,
           id: :pdex_member_match_operation_in_cap_stmt,
           title: 'Server declares support for Patient member match operation in CapabilityStatement',
           config: {
             options: { operation_name: 'member-match', operation_url: 'http://hl7.org/fhir/us/davinci-hrex/OperationDefinition/member-match' }
           }

      test from: :pdex_member_match_profile_validation do
        id :pdex_one_match_profile_validation
        title '[USER INPUT VALIDATION] Member match request for exactly one match is valid'
        description %{
          This test validates the conformity of the user input to the
          [HRex Member Match Request Profile](https://hl7.org/fhir/us/davinci-hrex/STU1/StructureDefinition-hrex-parameters-member-match-in.html),
          ensuring subsequent tests can accurately simulate content. It also checks conformance to the [Parameters Resource](https://hl7.org/fhir/R4/parameters.html),
          mandatory elements, and terminology.
        }
      end

      test from: :pdex_member_match_local_ref_validation do
        id :pdex_member_match_local_ref
        title '[USER INPUT VALIDATION] Member match request only uses local references'
      end

      test from: :pdex_coverage_to_link_minimal_validation
      test from: :pdex_coverage_to_link_ms_validation
   
      test do
        id :pdex_member_match_on_server
        title 'Server handles $member-match operation successfully'
        description 'Server receives request `POST [baseURL]/Patient/$member-match` and returns 200'
           
        input :member_match_request
   
        makes_request :member_match
   
        run do
          fhir_operation('/Patient/$member-match', body: FHIR.from_contents(member_match_request), name: :member_match)
          assert_response_status(200)
        end
      end
  
      test do
        id :pdex_member_match_response_profile
        title 'Server $member-match response conforms to profile'
        description %{
          The response body from the previous POST request to $member-match must be valid FHIR JSON conforming to
          [HRex Member Match Response Profile](https://hl7.org/fhir/us/davinci-hrex/STU1/StructureDefinition-hrex-parameters-member-match-out.html).
        }

        output :member_identifier
        output :member_identifier_system  

        uses_request :member_match

        run do
          assert response[:body], 'Server HTTP response is missing body'
          assert_valid_json(response[:body])
          assert_resource_type('Parameters')

          # We should save the output before validating every detail of the payload
          output member_identifier: resource.parameter.find{|p| p.name=='MemberIdentifier'}&.valueIdentifier&.value
          output member_identifier_system: resource.parameter.find{|p| p.name=='MemberIdentifier'}&.valueIdentifier&.system

          assert_valid_resource(profile_url: 'http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-parameters-member-match-out')
        end
      end
  
      test do
        id :pdex_member_match_identifier_to_id
        title 'Server member identifier from $member-match yields logical Patient id'
        description %Q{
          The $member-match operation returns a Member Identifier, and subsequent clinical queries and operations
          are only required to support logical Patient FHIR ID. Hence server must be able to provide a Patient
          FHIR ID from Member Identifier.

          Server receives request `GET [baseURL]/Patient?identifier=[member_identifier]`
          and returns 200 and a Bundle with a single FHIR Patient. The `[member_identifier]` is from Member Match Response
          `Parameters.parameter:MemberIdentifier.valueIdentifier.value`.
        }

        input :member_identifier
        input :member_identifier_system, optional: true
        output :patient_id

        run do
          skip_if !member_identifier, "No member identifier obtained from $member-match request"
 
          # We only query by identifier.value, and preset information happens to return a value with a system within it
          # which may be a bug.
          # Other options are to query by system|value or type-of:
          # But future PDex IG is intending to include logical FHIR id with MemberMatchResponse so this won't be necessary
          fhir_search(FHIR::Patient, params: { 'identifier' => member_identifier })

          assert response[:body], 'Server HTTP response is missing body'
          assert_valid_json(response[:body])
          assert_resource_type('Bundle')

          assert resource.entry.find{ |entry| entry.resource&.resourceType == 'Patient' }, "Bundle has no Patient resource."

          patient_id = resource.entry.reverse_each.find{ |entry| entry.resource&.resourceType == 'Patient' }&.resource&.id
          assert patient_id, "Patient resource in Bundle has no logical resource id"

          info "Multiple patients found, using the last patient id." if resource.entry.select{ |entry| entry.resource&.resourceType == 'Patient' }.length > 1

          output :patient_id => patient_id

          assert_valid_resource
        end
      end

    end
  end
end
