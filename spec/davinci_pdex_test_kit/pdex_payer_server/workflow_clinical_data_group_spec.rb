# frozen_string_literal: true
# workflow_clinical_data_group_spec.rb

require 'davinci_pdex_test_kit/pdex_payer_server/workflow_clinical_data_group'

RSpec.describe DaVinciPDexTestKit::PDexPayerServer::WorkflowClinicalDataGroup do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('pdex_payer_server_suite') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: 'pdex_payer_server_suite') }
  let(:url) { 'http://example.com/fhir' }
  let(:group) { suite.groups.first.groups[1] }
  let(:patient_id) { Faker::Alphanumeric.alphanumeric }
  let(:member_match_request) { '{}' }

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
          location: 'Resource.id',
          message: 'Test dummy error',
          level: 'ERROR'
        }]
      }],
      sessionId: ''
    }
  end

  #before(:each) do
  #end

  describe 'clinical encounter query test' do
    let(:test) { group.tests[0] }

    it 'skips without a patient id' do
      stub_request(:get, "#{url}/metadata")
        .to_return({
          status: 200,
          body: create(:capability_statement_with_encounter_search_interface).to_json
        })

      result = run(test_session, test, {url:, member_match_request:})
      expect(result.result).to eq('skip')
    end

    it 'sends an encounter search query' do     
      stub_request(:get, "http://example.com/fhir/metadata")
        .to_return({
          status: 200,
          body: create(:capability_statement_with_encounter_search_interface).to_json,
          headers: {'Content-Type' => 'application/fhir+json'}
        })

      stub_request(:get, "#{url}/Encounter")
        .with(query: {patient: "Patient/#{patient_id}"})
        .to_return(status: 501)

      result = run(test_session, test, {url:, patient_id:, member_match_request:})

      expect(WebMock).to have_requested(:get, "#{url}/Encounter?patient=Patient/#{patient_id}")
    end
  end
=begin
    it 'passes an HTTP 200 response' do
      stub_request(:get, "#{url}/metadata")
        .to_return({
          status: 200,
          #headers: {'Content-Type' => 'application/fhir+json'},
          body: create(:capability_statement_with_encounter_search_interface).to_json
        })

      stub_request(:get, "#{url}/Encounter")
        .with(query: {patient: "Patient/#{patient_id}"})
        .to_return(status: 200, body: create(:encounter_search_bundle).to_json)

      result = run(test_session, test, {url:, patient_id:, member_match_request:})
      expect(result.result).to eq('pass'), result.result_message
    end

    it 'fails an HTTP 404 not found response' do
      stub_request(:get, "#{url}/Encounter")
        .with(query: {patient: "Patient/#{patient_id}"})
        .to_return(status: 404)

      result = run(test_session, test, {url:, patient_id:, member_match_request:})
      expect(result.result).to eq('fail'), result.result_message
    end
  end
=end
=begin
  # TODO uses request fix
  describe 'clinical encounter data test' do
    let(:test) { group.tests[1] }

    it 'passes when encountersearch returns successfully' do
      stub_request(:get, "#{url}/Encounter")
        .with(query: {patient: "Patient/#{patient_id}"})
        .to_return(status: 200, body: create(:encounter_search_bundle).to_json)

      stub_request(:post, "#{ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')}/validate")
        .with(query: hash_including({}))
        .to_return(status: 200, body: success_outcome.to_json)

      result = run(test_session, test, {url:, patient_id:, member_match_request:})
      expect(result.result).to eq('pass'), result.result_message

    end
    
    it 'fails when encounter search returns empty bundle' do
      stub_request(:get, "#{url}/Encounter")
        .with(query: {patient: "Patient/#{patient_id}"})
        .to_return(status: 200, body: create(:empty_search_bundle).to_json)

      stub_request(:post, "#{ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')}/validate")
        .with(query: hash_including({}))
        .to_return(status: 200, body: success_outcome.to_json)

      result = run(test_session, test, {url:, patient_id:, member_match_request:})

      expect(result.result).to eq('fail'), result.result_message
    end    
  end
=end
end
