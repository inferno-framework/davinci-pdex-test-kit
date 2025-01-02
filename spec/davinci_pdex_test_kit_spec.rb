# davinci_pdex_test_kit_spec.rb

require_relative '../lib/davinci_pdex_test_kit.rb'

RSpec.describe DaVinciPDexTestKit, order: :defined do
  it_behaves_like 'platform_deployable_test_kit'
end
