# frozen_string_literal: true
# workflow_member_match_test_group_spec.rb

#require_relative '../../../lib/davinci_pdex_test_kit/pdex_payer_server/workflow_member_match_test_group'

# TODO: REDO THIS FILE FOR WORKFLOW MEMBER MATCH
=begin
RSpec.describe DaVinciPDexTestKit::PDexPayerServer::PatientOperationInCapabilityStatementTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('pdex_payer_server') }
  let(:group) { suite.groups[0] } # this is payer-to-payer workflow group
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: 'pdex_payer_server') }
  let(:url) { 'http://example.com/fhir' }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(test_session_id: test_session.id, type: 'text', name: name, value: value)
    end
    Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  end

  describe 'member-match in capability statement test' do
    let(:test) { group.groups[0].tests[0] }

    it 'passes if member-match is declared in Capability Statement' do
      metadata = FHIR::CapabilityStatement.new({
        status: 'active',
        date: '2024-06-12',
        kind: 'instance',
        implementation: {
          description: 'TEST DUMMY'
        },
        fhirVersion: '4.0.1',
        format: %w[json],
        rest: [
          {
            mode: 'server',
            resource: [
              {
                type: 'Patient',
                operation: [
                  {
                    name: 'member-match',
                    definition: 'http://hl7.org/fhir/us/davinci-hrex/OperationDefinition/member-match'
                  }
                ]
              }
            ]
          }
        ]
      })

      stub_request(:get, "#{url}/metadata").to_return(status: 200, headers: {'Content-Type' => 'application/json+fhir'}, body: metadata.to_json)

      result = run(test, {url:, member_match_request: FHIR::Parameters.new().to_json})
      expect(result.result).to eq('pass')
    end
  end

end
=end
