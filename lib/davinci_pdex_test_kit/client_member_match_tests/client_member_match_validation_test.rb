require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexInitialMemberMatchValidationTest < Inferno::Test
    include DaVinciPDexTestKit::ClientValidationTest
    include URLs

    id :initial_member_match_validation_test
    title 'Placeholder for showing the requests received and the responses given to each.'
    description %(
      
    )
    input :access_token

    run do
      skip_if !member_match_request.present?, "No previous member match request attempted"
      
      parameters = FHIR.from_contents(member_match_request.response_body)
      assert_resource_type(:parameters, resource: parameters)
      assert_valid_resource(resource: parameters, profile_url: 'http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-parameters-member-match-in')
    end
  end
end