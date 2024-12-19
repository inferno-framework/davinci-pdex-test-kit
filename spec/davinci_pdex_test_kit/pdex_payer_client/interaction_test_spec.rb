RSpec.describe DaVinciPDexTestKit::PDexClientSubmitMustSupportTest, :request do
  let(:suite_id) { 'pdex_payer_client' }

  def valid_json?(json)
    JSON.parse(json)
    true
  rescue JSON::ParserError, TypeError => e
    false
  end

  describe 'performing interactions with the client under test' do
    let(:access_token) { '1234' }
    let(:test) { described_class }
    let(:resume_continue_url) { "/custom/#{suite_id}/resume_clinical_data" }
    let(:results_repo) { Inferno::Repositories::Results.new }
    let(:inferno_host) { 'http://example.com/' }
    let(:request_headers) {{ 'Accept': 'application/json', 'Authorization': "Bearer #{access_token}" }}

    describe 'while waiting' do
      let(:reference_server_host) { 'localhost:8080' }
      let(:reference_server_url_prefix) { "http://#{reference_server_host}/reference-server/r4/" }
      let(:suite_fhir_url_prefix) { "#{inferno_host}custom/pdex_payer_client/fhir/"}

      it 'accepts and responds to an $everything request' do
        tested_request = 'Patient/999/$everything'
        allow_any_instance_of(DaVinciPDexTestKit::MockServer).to receive(:extract_bearer_token).and_return(access_token)
        allow(ENV).to receive(:fetch).with('FHIR_REFERENCE_SERVER').and_return(reference_server_url_prefix)
        allow(ENV).to receive(:fetch).with('HOST_HEADER').and_return(reference_server_host)
        stub_request(:get, "#{reference_server_url_prefix}#{tested_request}").
          to_return(status: 200, body: File.read(File.expand_path("../../fixtures/everything_response.fhir.json", __dir__)), headers: {})

        inputs = { access_token: }
        result = run(test, inputs)
        
        expect(result.result).to eq('wait')

        response = get("#{suite_fhir_url_prefix}#{tested_request}")
        expect(valid_json?(response.body)).to be(true)
        get(resume_continue_url, { 'token': access_token} )

        result = results_repo.find(result.id)
        expect(result.result).to eq('pass')
      end

      it 'accepts and responds to a patient search by identifier' do
        tested_request = 'Patient?identifier=99999'
        allow_any_instance_of(DaVinciPDexTestKit::MockServer).to receive(:extract_bearer_token).and_return(access_token)
        allow(ENV).to receive(:fetch).with('FHIR_REFERENCE_SERVER').and_return(reference_server_url_prefix)
        allow(ENV).to receive(:fetch).with('HOST_HEADER').and_return(reference_server_host)
        stub_request(:get, "#{reference_server_url_prefix}#{tested_request}").
          to_return(status: 200, body: File.read(File.expand_path("../../fixtures/patient_identifier_response.fhir.json", __dir__)), headers: {})

        inputs = { access_token: }
        result = run(test, inputs)

        expect(result.result).to eq('wait')

        response = get("#{suite_fhir_url_prefix}#{tested_request}")
        expect(valid_json?(response.body)).to be(true)
        get(resume_continue_url, { 'token': access_token} )

        result = results_repo.find(result.id)
        expect(result.result).to eq('pass')

      end
    end

    
  end
end
