require_relative 'lib/davinci_pdex_test_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'davinci_pdex_test_kit'
  spec.version       = DaVinciPDexTestKit::VERSION
  spec.authors       = ['Karl Naden', 'Shaumik Ashraf', 'Diego Griese']
  spec.email         = ['inferno@groups.mitre.org']
  spec.date          = Time.now.utc.strftime('%Y-%m-%d')
  spec.summary       = 'Da Vinci PDex Test Kit'
  spec.description   = 'Test Kit for the Da Vinci Payer Data Exchange (PDex) FHIR Implementation Guide'
  spec.homepage      = 'https://github.com/inferno-framework/davinci-pdex-test-kit/'
  spec.license       = 'Apache-2.0'
  spec.add_runtime_dependency 'inferno_core', '~> 0.4.38'
  spec.add_runtime_dependency 'us_core_test_kit', '~> 0.7.1'
  spec.add_runtime_dependency 'bulk_data_test_kit', '~> 0.10'
  spec.add_development_dependency 'database_cleaner-sequel', '~> 1.8'
  spec.add_development_dependency 'factory_bot', '~> 6.1'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'webmock', '~> 3.11'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.1.2')
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/inferno-framework/davinci-pdex-test-kit/'
  spec.files = [
    Dir['lib/**/*.rb'],
    Dir['lib/**/*.json'],
    Dir['lib/**/*.md'],
    Dir['lib/**/*.yml'],
    Dir['lib/**/*.yaml'],
    'LICENSE'
  ].flatten

  spec.require_paths = ['lib']
end
