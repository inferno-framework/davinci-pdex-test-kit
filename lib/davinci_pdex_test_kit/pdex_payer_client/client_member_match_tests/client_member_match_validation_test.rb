require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexInitialMemberMatchValidationTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_initial_member_match_validation
      title 'Client provides a valid $member-match request'
      description %(
        This test will validate the received $member-match-request input, ensuring it corresponds to the
        [HRex member-match-in profile](http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-parameters-member-match-in).
      )
      input :access_token
  
      run do
        skip_if !member_match_request.present?, "No previous $member-match request received"
        
        parameters = FHIR.from_contents(member_match_request.request_body)
        assert_resource_type(:parameters, resource: parameters)
        assert_valid_resource(resource: parameters, profile_url: 'http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-parameters-member-match-in')
      end
    end
  end
end
