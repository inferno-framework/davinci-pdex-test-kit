# pdex_profile_validation_group_spec.rb

require 'davinci_pdex_test_kit/pdex_resource_validator/pdex_profile_validation_group'

RSpec.describe DaVinciPDexTestKit::PDexResourceValidator::PDexProfileValidationGroup do
  let(:suite) do
    Inferno::Repositories::TestSuites.new.insert(Class.new(Inferno::TestSuite) do
      title 'RSpec mock suite'
      id :rspec_mock_suite
 
      group from: :pdex_profile_validation_group,
            id: :rspec_import_group,
            config: {
              inputs: {
                target: { 
                  name: :renamed_input,
                  type: 'textarea',
                  title: 'Custom input title',
                  description: 'Custom input description',
                  optional: true
                }
              },
              options: {
                resource_type: 'Patient',
                profile_name: 'Custom Profile',
                profile_url: 'http://example.com/fhir/realm/StructureDefinition/custom-profile',
                title: 'Custom Title',
                short_title: 'Custom Short Title',
                description: 'Custom markdown description'
              }
            }

    end)
  end

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

  # TODO debug
  context 'imported with all possible options and inputs' do
    let(:group) { suite.groups.first }

    before(:each) do
      stub_request(:post, "#{ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')}/validate")
        .with(query: hash_including({}))
        .to_return(status: 200, body: success_outcome.to_json)
    end


    it 'runs with renamed input' do
      result = run(test_session, group, {renamed_input: create(:member_match_request)})

      puts ''
      puts '----'
      puts result.result
      puts result.result_message
      puts '----'

      # binding.pry

      expect(result.result).to eq('pass')
    end    
  end

end
