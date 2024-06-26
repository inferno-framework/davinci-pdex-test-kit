# frozen_string_literal: true
# workflow_member_match_test_group_spec.rb

require 'davinci_pdex_test_kit/pdex_payer_server/workflow_member_match_group'

RSpec.describe DaVinciPDexTestKit::PDexPayerServer::WorkflowMemberMatchGroup do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('pdex_payer_server') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: 'pdex_payer_server_suite') }
  let(:url) { 'http://example.com/fhir' }

  let(:group) { deep_group_find(suite, 'pdex_workflow_member_match_group') }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(test_session_id: test_session.id, type: 'text', name: name, value: value)
    end
    Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  end

  def deep_group_find(suite_or_group, target_id)
    return nil if suite_or_group.nil?
    return suite_or_group if suite_or_group.is_a?(Inferno::TestGroup) && (suite_or_group.id == target_id)

    suite_or_group.groups.each do |g|
      group = deep_group_find(g, target_id)
      return group if group
    end

    nil
  end

  def deep_test_find(test_or_group, target_id)
    return nil if test_or_group.nil?

    if test_or_group.is_a? Inferno::Test
      return test_or_group.id == target_id ? test_or_group : nil
    else
      test_or_group.tests.each do |t|
        test = deep_test_find(t, target_id)
        return test if test
      end
      test_or_group.groups.each do |g|
        return deep_test_find(g, target_id)
      end
    end

    nil
  end

  describe 'member-match in capability statement test' do
    let(:test) { deep_test_find(group, 'member_match_operation_in_capability_statement_test') }

    it 'passes if member-match is declared in Capability Statement under Patient resource' do
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

    it 'fails if member-match is not declared in Capability Statement' do
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
            resource: []
          }
        ]
      })

      stub_request(:get, "#{url}/metadata").to_return(status: 200, headers: {'Content-Type' => 'application/json+fhir'}, body: metadata.to_json)

      result = run(test, {url:, member_match_request: FHIR::Parameters.new().to_json})
      expect(result.result).to eq('fail')
    end
  end

end
