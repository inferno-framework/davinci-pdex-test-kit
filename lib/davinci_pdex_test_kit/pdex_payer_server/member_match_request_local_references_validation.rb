module DaVinciPDexTestKit
  module PDexPayerServer

    # Factorized test for Member Match Request Profile local references on PDex v2.0.0 and HRex v1.0.0.
    #
    # See http://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html#resolving-parameter-references
    #
    # ==== Inputs
    #
    # +member_match_request+ - *Optional:* FHIR Parameters resource JSON text
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
    # Skips if no input provided. This test does not validate all requirements of a Member Match Request
    # resource. 
    #
    class MemberMatchRequestLocalReferencesValidation < Inferno::Test
      id :pdex_member_match_local_ref_validation

      title '[USER INPUT VALIDATION] Member match request only uses local references'

      description %{
        This test confirms that all Patient references inside the Consent and CoverageToMatch parameters are local references to the MemberPatient
        parameter. See
        [resolving parameter references](https://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html#resolving-parameter-references)
        from the HRex 1.0.0. Implementation Guide.
      }

      input :member_match_request

      # @param member_match_request_parameters [FHIR::Parameters]
      def assert_local_patient_references(member_match_request_parameters)
        # $member-match has references requirements on its Parameters profile not coded as FHIR constraints
        # see https://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html#resolving-parameter-references
        parameter_patient_id = member_match_request_parameters.parameter.find{|p| p.name== 'MemberPatient'}.resource.id
        assert member_match_request_parameters.parameter.find{|p| p.name== 'Consent'}&.resource&.patient&.reference == "Patient/#{parameter_patient_id}",
          "The reference to Patient resource in Consent parameter must be a local reference referring to MemberPatient with matching id"
        assert member_match_request_parameters.parameter.find{|p| p.name== 'CoverageToMatch'}&.resource&.beneficiary&.reference == "Patient/#{parameter_patient_id}",
          "The reference to Patient resource in CoverageToMatch parameter must be a local reference referring to MemberPatient with matching id"
      end

      run do
        skip_if !member_match_request, "No input provided."

        assert_local_patient_references( FHIR.from_contents(member_match_request) )
      end
    end
  end
end
