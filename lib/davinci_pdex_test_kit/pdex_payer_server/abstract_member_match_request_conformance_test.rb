module DaVinciPDexTestKit
  module PDexPayerServer

    # Exists to factorize input validation
    class AbstractMemberMatchRequestConformanceTest < Inferno::Test      
      id :abstract_member_match_request_conformance
      input :member_match_request

      def assert_local_patient_references(member_match_request_parameters)
        # $member-match has references requirements on its Parameters profile not coded as FHIR constraints
        # see https://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html#resolving-parameter-references
        parameter_patient_id = member_match_request_parameters.parameter.find{|p| p.name== 'MemberPatient'}.resource.id
        assert member_match_request_parameters.parameter.find{|p| p.name== 'Consent'}.resource.patient.reference == "Patient/#{parameter_patient_id}",
          "The reference to Patient resource in Consent parameter must be a local reference referring to MemberPatient with matching id"
        assert member_match_request_parameters.parameter.find{|p| p.name== 'CoverageToMatch'}.resource.beneficiary.reference == "Patient/#{parameter_patient_id}",
          "The reference to Patient resource in CoverageToMatch parameter must be a local reference referring to MemberPatient with matching id"
      end

      def assert_member_match_request(member_match_request_json)
        # assert_valid_json(member_match_request_json)
        member_match_request_resource = FHIR.from_contents(member_match_request_json) # TODO: handle case if it fails to parse as FHIR, but is valid JSON
        assert_valid_resource(resource: member_match_request_resource, profile_url: 'http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-parameters-member-match-in')
        assert_local_patient_references(member_match_request_resource)
      end

      run do
        skip_if !member_match_request, "No input provided."

        assert_member_match_request(member_match_request)
      end
    end
  end
end
