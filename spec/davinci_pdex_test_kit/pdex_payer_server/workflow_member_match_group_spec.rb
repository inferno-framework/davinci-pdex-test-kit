# frozen_string_literal: true
# workflow_member_match_test_group_spec.rb

require 'davinci_pdex_test_kit/pdex_payer_server/workflow_member_match_group'

RSpec.describe DaVinciPDexTestKit::PDexPayerServer::WorkflowMemberMatchGroup do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('pdex_payer_server_suite') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: 'pdex_payer_server_suite') }
  let(:url) { 'http://example.com/fhir' }
  let(:group) { suite.groups.first.groups.first }

  let(:success_outcome) do
    {
      outcomes: [{
        issues: []
      }],
      sessionId: ''
    }
  end

  let(:error_outcome) do
    {
      outcomes: [{
        issues: [{
          location: 'Parameters.id',
          message: 'Test dummy error',
          level: 'ERROR'
        }]
      }],
      sessionId: ''
    }
  end

  describe 'member-match in capability statement test' do
    let(:test) { group.tests.first }

    it 'passes if member-match is declared in Capability Statement under Patient resource' do
      metadata = create(:capability_statement_with_patient_member_match)

      stub_request(:get, "#{url}/metadata").to_return(status: 200, headers: {'Content-Type' => 'application/fhir+json'}, body: metadata.to_json)

      result = run(test_session, test, {url:, member_match_request: FHIR::Parameters.new().to_json})

      expect(result.result).to eq('pass'), result.result_message
    end

    it 'fails if member-match is not declared in Capability Statement' do
      metadata = create(:capability_statement_with_patient_resource)

      stub_request(:get, "#{url}/metadata").to_return(status: 200, headers: {'Content-Type' => 'application/json+fhir'}, body: metadata.to_json)

      result = run(test_session, test, {url:, member_match_request: FHIR::Parameters.new().to_json})
      expect(result.result).to eq('fail'), result.result_message
    end

    it 'fails if member-match is declared under the wrong resource' do
      metadata = create(:capability_statement_with_bad_member_match)

      stub_request(:get, "#{url}/metadata").to_return(status: 200, headers: {'Content-Type' => 'application/json+fhir'}, body: metadata.to_json)

      result = run(test_session, test, {url:, member_match_request: FHIR::Parameters.new().to_json})
      expect(result.result).to eq('fail'), result.result_message
    end
  end

  describe 'member match request profile test' do
    let(:test) { group.tests[1] }

    it 'passes a correct member match request resource' do
      parameters = create(:member_match_request)
      stub_request(:post, "#{ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')}/validate")
        .with(query: hash_including({}))
        .to_return(status: 200, body: success_outcome.to_json)

      result = run(test_session, test, {url:, member_match_request: parameters.to_json})
      expect(result.result).to eq('pass'), result.result_message
    end

    it 'fails a bad member match request resource' do
      parameters = create(:bad_member_match_request)
      stub_request(:post, "#{ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')}/validate")
        .with(query: hash_including({}))
        .to_return(status: 200, body: error_outcome.to_json)

      result = run(test_session, test, {url:, member_match_request: parameters.to_json})
      expect(result.result).to eq('fail'), result.result_message
    end
  end

  describe 'member match request local references test' do
    let(:test) { group.tests[2] }

    it 'passes a correct member match request resource' do
      parameters = create(:member_match_request)
      result = run(test_session, test, {url:, member_match_request: parameters.to_json})
      expect(result.result).to eq('pass'), result.result_message
    end
  end

  describe 'coverage to link minimal data test' do
    let(:test) { group.tests[3] }

    it 'passes a correct member match request resource' do
      parameters = create(:member_match_request)
      result = run(test_session, test, {url:, member_match_request: parameters.to_json})
      expect(result.result).to eq('pass'), result.result_message
    end

    it 'skips a member match request resource without coverage to link parameter' do
      parameters = create(:member_match_request_without_coverage_to_link)
      result = run(test_session, test, {url:, member_match_request: parameters.to_json})
      expect(result.result).to eq('skip'), result.result_message
    end
  end

  describe 'coverage to link must support test' do
    let(:test) { group.tests[4] }

    it 'passes a correct member match request resource' do
      parameters = create(:member_match_request)
      result = run(test_session, test, {url:, member_match_request: parameters.to_json})
      expect(result.result).to eq('pass'), result.result_message
    end
  end

  describe 'member match on server test' do
    let(:test) { group.tests[5] }
    let (:member_match_request) { create(:member_match_request).to_json }

    it 'executes $member-match operation' do
      stub_request(:post, "#{url}/Patient/$member-match").to_return(status: 200)

      result = run(test_session, test, {url:, member_match_request:})
      expect(WebMock).to have_requested(:post, "#{url}/Patient/$member-match").
        with(body: member_match_request, headers: {'Content-Type' => 'application/fhir+json'})
    end

    it 'passes a 200 response' do
      stub_request(:post, "#{url}/Patient/$member-match").to_return(status: 200)

      result = run(test_session, test, {url:, member_match_request:})
      expect(result.result).to eq('pass'), result.result_message
    end

    it 'fails 500 response' do
      stub_request(:post, "#{url}/Patient/$member-match").to_return(status: 500)

      result = run(test_session, test, {url:, member_match_request:})
      expect(result.result).to eq('fail'), result.result_message
    end
  end

  # TODO: figure out how to stub `uses_request` for below:
  # describe 'member match response profile test' do
  #   let(:test) { group.tests[6] }
  #   let(:member_match_request) { create(:member_match_request).to_json }
  #   let(:member_match_response) { create(:member_match_response) }
  # 
  #   before(:each) do
  #     allow(test).to receive(:requests).and_return(Inferno::Entities::Request.new({
  #       name: 'member_match',
  #       verb: 'post',
  #       url: "#{url}/Patient/$member-match",
  #       request_body: member_match_request,
  #       response_body: member_match_response.to_json,
  #       direction: 'outgoing',
  #       headers: [
  #         Inferno::Entities::Header.new({name: 'Accept', type: 'request', value: 'application/fhir+json'}),
  #         Inferno::Entities::Header.new({name: 'Content-Type', type: 'response', value: 'application/fhir+json'})
  #       ]
  #     }))
  #     allow(test).to receive(:load_named_requests).and_return(true)
  # 
  #     stub_request(:post, "#{ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')}/validate")
  #       .with(query: hash_including({}))
  #       .to_return(status: 200, body: success_outcome.to_json)
  #   end
  # 
  #   it 'passes a correct member match response resource' do
  #     result = run(test_session, test, {url:, member_match_request:})
  #     expect(result.result).to eq('pass'), result.result_message
  #   end
  # 
  #   it 'outputs member identifier' do
  #     result = run(test_session, test, {url:, member_match_request:})
  #     expect( JSON.parse(result.output_json).empty?).to be(false), result.result_message
  #   end
  # end

  describe 'member match identifier to id test' do
    let(:test) { group.tests[7] }
    let(:member_identifier) { '42' }    # Parameters.parameter:MemberIdentifier.valueIndentifier.value
    let(:member_match_request) { '{}' } # FIXME: test still requires input when it shouldn't, probably because its nested

    it 'skips without a member identifier' do
      result = run(test_session, test, {url:, member_match_request:})
      expect(result.result).to eq('skip'), result.result_message
    end

    it 'sends an identifier query' do
      stub_request(:get, "#{url}/Patient")
        .with(query: {identifier: member_identifier})
        .to_return(status: 501)

      result = run(test_session, test, {url:, member_identifier:, member_match_request:})

      expect(WebMock).to have_requested(:get, "#{url}/Patient?identifier=#{member_identifier}")
    end

    it 'passes when patient search returns successfully' do
      stub_request(:get, "#{url}/Patient")
        .with(query: {identifier: member_identifier})
        .to_return(status: 200, body: create(:patient_search_bundle).to_json)

      stub_request(:post, "#{ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')}/validate")
        .with(query: hash_including({}))
        .to_return(status: 200, body: success_outcome.to_json)

      result = run(test_session, test, {url:, member_identifier:, member_match_request:})

      expect(result.result).to eq('pass'), result.result_message
    end
    
    it 'fails when patient search returns empty bundle' do
      stub_request(:get, "#{url}/Patient")
        .with(query: {identifier: member_identifier})
        .to_return(status: 200, body: create(:empty_search_bundle).to_json)

      stub_request(:post, "#{ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')}/validate")
        .with(query: hash_including({}))
        .to_return(status: 200, body: success_outcome.to_json)

      result = run(test_session, test, {url:, member_identifier:, member_match_request:})

      expect(result.result).to eq('fail'), result.result_message
    end    
  end

end
