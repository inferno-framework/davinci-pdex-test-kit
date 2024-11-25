module DaVinciPDexTestKit
  class Metadata < Inferno::Entities::TestKit
    # TODO refactor gemspec
    id :davinci_pdex_test_kit
    title 'DaVinci PDex Test Kit'
    description <<~DESCRIPTION
      See <https://inferno.healthit.gov/test-kits/davinci-pdex/>
    DESCRIPTION
    suite_ids %w[pdex_payer_server_suite pdex_payer_client_suite]
    tags ['Da Vinci']
    last_updated '2024-11-25'
    version DaVinciPDexTestKit::VERSION # TODO fix import
    maturity 'Low'
    authors ['Karl Naden', 'Shaumik Ashraf', 'Diego Griese']
    repo 'https://github.com/inferno-framework/davinci-pdex-test-kit'
  end
end
