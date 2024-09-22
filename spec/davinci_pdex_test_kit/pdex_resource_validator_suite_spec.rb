
require 'davinci_pdex_test_kit/pdex_resource_validator_suite'

RSpec.describe DaVinciPDexTestKit::PDexResourceValidatorSuite do
  let(:suite) { described_class }

  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:url) { 'http://example.com/fhir' }

  let(:success_outcome) do
    {
      outcomes: [{
        issues: []
      }],
      sessionId: ''
    }
  end

  context 'prior authorization group' do
    let(:group) { suite.groups.first }

    before(:each) do
      stub_request(:post, "#{ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')}/validate")
        .with(query: hash_including({}))
        .to_return(status: 200, body: success_outcome.to_json)
    end

    it 'omits if no inputs provided' do
      result = run(test_session, group)

      expect(result.result).to eq('omit')
    end    
  end

end
