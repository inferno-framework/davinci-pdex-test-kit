require_relative 'lib/davinci_pdex_test_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'davinci_pdex_test_kit'
  spec.version       = DaVinciPDexTestKit::VERSION
  spec.authors       = ['Karl Naden', 'Shaumik Ashraf', 'Diego Griese']
  spec.date          = Time.now.utc.strftime('%Y-%m-%d')
  spec.summary       = 'Da Vinci PDex Test Kit'
  spec.description   = 'Test Kit for the Da Vinci Payer Data Exchange (PDex) FHIR Implementation Guide'
  spec.homepage      = 'https://github.com/inferno-framework/davinci-pdex-test-kit/'
  spec.license       = 'Apache-2.0'
  spec.add_runtime_dependency 'inferno_core', '~> 0.6.16'
  spec.add_runtime_dependency 'us_core_test_kit', '~> 0.11.5'
  spec.add_runtime_dependency 'bulk_data_test_kit', '~> 0.12.3'
  spec.add_runtime_dependency 'faraday', '~> 1.10.4'
  spec.add_runtime_dependency 'faraday_middleware', '~> 1.2.1'
  spec.add_runtime_dependency 'smart_app_launch_test_kit', '~> 0.6.4'
  spec.add_runtime_dependency 'udap_security_test_kit', '~> 0.11.6'
  spec.add_development_dependency 'database_cleaner-sequel', '~> 1.8'
  spec.add_development_dependency 'factory_bot', '~> 6.1'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'webmock', '~> 3.11'
  spec.add_development_dependency 'faker', '~> 3.4'
  spec.add_development_dependency 'roo', '~> 2.10.1'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.3.6')
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/inferno-framework/davinci-pdex-test-kit/'
  spec.files         = `[ -d .git ] && git ls-files -z lib config/presets LICENSE`.split("\x0")
  spec.require_paths = ['lib']
  spec.metadata['inferno_test_kit'] = 'true'
end
