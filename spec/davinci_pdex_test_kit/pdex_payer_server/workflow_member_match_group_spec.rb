# frozen_string_literal: true
# workflow_member_match_test_group_spec.rb

require 'davinci_pdex_test_kit/pdex_payer_server/workflow_member_match_group'

RSpec.describe DaVinciPDexTestKit::PDexPayerServer::WorkflowMemberMatchGroup do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('pdex_payer_server_suite') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: 'pdex_payer_server_suite') }
  let(:url) { 'http://example.com/fhir' }
  let(:group) { suite.groups.first.groups.first }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(test_session_id: test_session.id, type: 'text', name: name, value: value)
    end
    Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  end


  describe 'member-match in capability statement test' do
    let(:test) { group.tests.first }

    it 'passes if member-match is declared in Capability Statement under Patient resource' do
      metadata = create(:capability_statement_with_patient_member_match)

      stub_request(:get, "#{url}/metadata").to_return(status: 200, headers: {'Content-Type' => 'application/fhir+json'}, body: metadata.to_json)

      result = run(test, {url:, member_match_request: FHIR::Parameters.new().to_json})

      expect(result.result).to eq('pass')
    end

    it 'fails if member-match is not declared in Capability Statement' do
      metadata = create(:capability_statement_with_patient_resource)

      stub_request(:get, "#{url}/metadata").to_return(status: 200, headers: {'Content-Type' => 'application/json+fhir'}, body: metadata.to_json)

      result = run(test, {url:, member_match_request: FHIR::Parameters.new().to_json})
      expect(result.result).to eq('fail')
    end

    it 'fails if member-match is declared under the wrong resource' do
      metadata = create(:capability_statement_with_bad_member_match)
    end

  end
end
