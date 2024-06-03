# frozen_string_literal: true
require_relative 'abstract_member_match_request_conformance_test'
require_relative 'abstract_member_match_request_local_references_test'
require_relative 'coverage_to_link_has_minimal_data_test'
require_relative 'coverage_to_link_must_support_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class WorkflowMemberMatch < Inferno::TestGroup
      title 'Server can return a matching member in response to $member-match request'
      short_title '$member-match'
      id :workflow_member_match
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
        2. Execute a successful member-match workflow:
          + validate input
          + POST request to server and validate HTTP 200 response status
          + validate memeber match response conforms to profile
          + use member identifier from response to query for patient id 
      }

      group do
        id :member_match_capability_statement_group
        title 'CapabilityStatement'

        run_as_group

        test do
          id :member_match_in_capability_statement
          title 'Server asserts Patient $member_match operation in capability statement.'

          run do
            fhir_get_capability_statement

            assert_response_status(200)
            assert_resource_type(:capability_statement)

            # fail unless resource.rest[0].resource.find{|r| r.type=='Patient'}&.operation&.find do |op|
            #   op.definition == ''
            # end

            assert(
              resource.rest.one? do |rest_metadata|
                rest_metadata.resource.select { |resource_metadata| resource_metadata.type == 'Patient' }.first
                  .operation.any? do |operation_metadata|
                    operation_metadata.name == 'member-match' && operation_metadata.definition == 'http://hl7.org/fhir/us/davinci-hrex/OperationDefinition/member-match'
                  end
              end
            )
          end
        end
      end

      group do
        id :member_match_request_group
        title '$member-match with exactly one match'

        run_as_group

        input :member_match_request,
          title: 'Member Match Request for one match',
          description: "A JSON payload for server's $member-match endpoint that has **exactly one match**",
          type: 'textarea'

        test from: :abstract_member_match_request_conformance do
          id :member_match_request_request_conformance
          title '[USER INPUT VALIDATION] Member match request for exactly one match is valid'
          description %{
            This test validates the conformity of the user input to the
            [HRex Member Match Request Profile](https://hl7.org/fhir/us/davinci-hrex/STU1/StructureDefinition-hrex-parameters-member-match-in.html),
            ensuring subsequent tests can accurately simulate content. It also checks conformance to the [Parameters Resource](https://hl7.org/fhir/R4/parameters.html),
            mandatory elements, and terminology.
          }
        end

        test from: :abstract_member_match_request_local_references do
          id :member_match_request_local_references
        end
  
        test do
          id :member_match_on_server
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
          id :member_match_response_conformance
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
            assert_valid_resource(profile_url: 'http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-parameters-member-match-out')
  
            output member_identifier: resource.parameter.find{|p| p.name=='MemberIdentifier'}.valueIdentifier.value
            output member_identifier_system: resource.parameter.find{|p| p.name=='MemberIdentifier'}.valueIdentifier.system
          end
        end
    
        test do
          id :member_match_identifier_to_id
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
 
            # We only query by identifier.value, and preset information happens to give a value with a system within it
            # which may be a bug.
            # Other options are to query by system|value or type-of:
            # But future PDex IG is intending to include logical FHIR id with MemberMatchResponse so this won't be necessary
            fhir_search(FHIR::Patient, params: { 'identifier' => member_identifier })

            # Uncomment for search by system|value:
            # unless member_identifier_system.empty?
            #   fhir_search(FHIR::Patient, params: { 'identifier' => "#{member_identifier_system}|#{member_identifier}" })
            # else
            #   fhir_search(FHIR::Patient, params: { 'identifier' => member_identifier })
            # end

            assert response[:body], 'Server HTTP response is missing body'
            assert_valid_json(response[:body])
            assert_resource_type('Bundle')

            # XXX skip or fail? this is not formally part of the spec
            skip "Bundle has no Patient resource." unless resource.entry.find{ |entry| entry.resource&.resourceType == 'Patient' }

            patient_id = resource.entry.reverse_each.find{ |entry| entry.resource&.resourceType == 'Patient' }&.resource&.id
            assert patient_id, "Patient resource in Bundle has no logical resource id"

            output :patient_id => patient_id

            # Uncomment for search by system|value
            # if member_identifier_system
            #   if resource.entry.select{ |entry| entry.resource&.resourceType == 'Patient' }.length > 1
            #     info "Chose the last Patient's ID."
            #     skip "Bundle has more than one Patient resource."
            #   end
            # else
            #   skip_if resource.entry.select{ |entry| entry.resource&.resourceType == 'Patient' }.length > 1,
            #   "Bundle has more than one Patient resource. You may need to return a MemberIdentifier system with your $member-match operation."
            # end

            assert_valid_resource
          end
        end

        test from: :coverage_to_link_has_minimal_data
        test from: :coverage_to_link_must_support
      end

    end
  end
end
