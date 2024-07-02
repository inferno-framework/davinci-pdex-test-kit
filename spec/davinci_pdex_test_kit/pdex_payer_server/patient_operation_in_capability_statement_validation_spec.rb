# frozen_string_literal: true

require 'davinci_pdex_test_kit/pdex_payer_server/patient_operation_in_capability_statement_validation'

RSpec.describe DaVinciPDexTestKit::PDexPayerServer::PatientOperationInCapabilityStatementValidation do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('pdex_payer_server_suite') }
  let(:group) { suite.groups[0] } # this is payer-to-payer workflow group
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: 'pdex_payer_server_suite') }
  let(:url) { 'http://example.com/fhir' }

  describe 'member-match in capability statement test' do
    let(:test) { group.groups[0].tests[0] }

    it 'passes if member-match is declared in Capability Statement' do
      metadata = create(:capability_statement_with_patient_member_match)

      stub_request(:get, "#{url}/metadata").to_return(status: 200, headers: {'Content-Type' => 'application/json+fhir'}, body: metadata.to_json)

      result = run(test_session, test, {url:, member_match_request: FHIR::Parameters.new().to_json})
      expect(result.result).to eq('pass')
    end
  end

end
