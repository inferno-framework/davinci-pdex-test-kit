# frozen_string_literal: true
# workflow_everything_group_spec.rb

require 'davinci_pdex_test_kit/pdex_payer_server/workflow_everything_group'

RSpec.describe DaVinciPDexTestKit::PDexPayerServer::WorkflowEverythingGroup do
  let(:suite_id) { 'pdex_payer_server' }
  let(:url) { 'http://example.com/fhir' }
  let(:group) { suite.groups.first.groups[2] }
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

  describe 'everything operation in capability statement test' do
    let(:test) { group.tests[0] }

    it 'passes if everything operation is declared in Capability Statement under Patient resource' do
      metadata = create(:capability_statement_with_patient_everything)

      stub_request(:get, "#{url}/metadata").to_return(status: 200, headers: {'Content-Type' => 'application/fhir+json'}, body: metadata.to_json)

      result = run(test, {url:})

      expect(result.result).to eq('pass'), result.result_message
    end

    it 'fails if everything operation is not declared in Capability Statement' do
      metadata = create(:capability_statement_with_patient_resource)

      stub_request(:get, "#{url}/metadata").to_return(status: 200, headers: {'Content-Type' => 'application/json+fhir'}, body: metadata.to_json)

      result = run(test, {url:})
      expect(result.result).to eq('fail'), result.result_message
    end

    it 'fails if everything operation is declared under the wrong resource' do
      metadata = create(:capability_statement_with_bad_everything)

      stub_request(:get, "#{url}/metadata").to_return(status: 200, headers: {'Content-Type' => 'application/json+fhir'}, body: metadata.to_json)

      result = run(test, {url:})
      expect(result.result).to eq('fail'), result.result_message
    end

  end

  describe 'everything operation test' do
    let(:test) { group.tests[1] }

    before(:each) do
      stub_request(:get, "#{url}/metadata")
        .to_return({
          status: 200,
          body: create(:capability_statement_with_encounter_search_interface).to_json
        })      
    end

    it 'skips without a patient id' do
      result = run(test, {url:})
      expect(result.result).to eq('skip'), result.result_message
    end

    it 'sends a $everything request' do     
      stub_request(:get, "#{url}/Patient/#{patient_id}/$everything")
        .to_return(status: 501)

      result = run(test, {url:, patient_id:})

      expect(WebMock).to have_requested(:get, "#{url}/Patient/#{patient_id}/$everything")
    end

    it 'passes an HTTP 200 response' do
      stub_request(:get, "#{url}/Patient/#{patient_id}/$everything")
        .to_return(status: 200, body: create(:everything_bundle).to_json)

      result = run(test, {url:, patient_id:})
      expect(result.result).to eq('pass'), result.result_message
    end

    it 'fails an HTTP 404 not found response' do
      stub_request(:get, "#{url}/Patient/#{patient_id}/$everything")
        .to_return(status: 404)

      result = run(test, {url:, patient_id:})
      expect(result.result).to eq('fail'), result.result_message
    end
  end

  # TODO implement Inferno `uses_request` mock
  # describe 'pdex bundle test' do
  #   let(:test) { group.tests[2] }
  # 
  #   it 'passes when encounter search returns successfully' do
  #     stub_request(:get, "#{url}/Patient/#{patient_id}/$everything")
  #       .to_return(status: 200, body: create(:everything_bundle).to_json)
  # 
  #     stub_request(:post, "#{ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')}/validate")
  #       .with(query: hash_including({}))
  #       .to_return(status: 200, body: success_outcome.to_json)
  # 
  #     result = run(test, {url:, patient_id:})
  #     expect(result.result).to eq('pass'), result.result_message
  # 
  #   end
  #   
  #   it 'fails when encounter search returns empty bundle' do
  #     stub_request(:get, "#{url}/Patient/#{patient_id}/$everything")
  #       .to_return(status: 200, body: create(:empty_search_bundle).to_json)
  # 
  #     stub_request(:post, "#{ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')}/validate")
  #       .with(query: hash_including({}))
  #       .to_return(status: 200, body: success_outcome.to_json)
  # 
  #     result = run(test, {url:, patient_id:})
  # 
  #     expect(result.result).to eq('fail'), result.result_message
  #   end    
  # end

end
