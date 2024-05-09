require_relative '../client_validation_test.rb'
require_relative '../group_metadata.rb'

module DaVinciPDexTestKit
  class PDexInitialMemberMatchMustSupportValidationTest < Inferno::Test
    include DaVinciPDexTestKit::ClientValidationTest
    include DaVinciPDexTestKit::MustSupportTest
    include URLs

    id :initial_member_match_must_support_validation_test
    title 'Placeholder for showing the requests received and the responses given to each.'
    description %(
      
    )
    input :access_token

    def resource_type
      'Parameters'
    end

    def self.metadata
      @metadata ||= DaVinciPDexTestKit::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
    end

    run do

      assert all_member_match_requests, "No previous member match requests attempted"

      perform_must_support_test(all_member_match_requests.map {|match_request| FHIR::Parameters.new(JSON.parse(member_match_request.request_body).to_h)})
    end
  end
end