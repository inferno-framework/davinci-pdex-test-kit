require_relative 'version'

module DaVinciPDexTestKit
  class Metadata < Inferno::TestKit
    id :pdex_test_kit
    title 'DaVinci PDex Test Kit'
    suite_ids ['pdex_payer_server', 'pdex_payer_client']
    tags ['Da Vinci']
    last_updated DaVinciPDexTestKit::LAST_UPDATED
    version DaVinciPDexTestKit::VERSION
    maturity 'Low'
    authors ['Karl Naden', 'Shaumik Ashraf', 'Diego Griese']
    repo 'https://github.com/inferno-framework/davinci-pdex-test-kit'
    description File.read(File.expand_path('docs/davinci_pdex_test_kit_description_v200.md', __dir__))
  end
end
