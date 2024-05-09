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
      assert member_match_request, "No previous member match request attempted"
      resource_is_valid?(resource: FHIR::Parameters.new(JSON.parse(member_match_request.request_body).to_h), profile_url: 'http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-parameters-member-match-in')
      errors_found = messages.select { |message| message[:type] == 'error' }
      errors_found_string = errors_found.map { |error| error[:message] }.to_s
      assert !errors_found.nil?, "Resource does not conform to the [Member Match Input profile](http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-parameters-member-match-in).  Errors found:\n #{errors_found_string}"
    end
  end
end