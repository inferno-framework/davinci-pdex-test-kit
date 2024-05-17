Gem::Specification.new do |spec|
  spec.name          = 'davinci_pdex_test_kit'
  spec.version       = '0.0.1'
  spec.authors       = ['Inferno Team']
  # spec.email         = ['TODO']
  spec.date          = Time.now.utc.strftime('%Y-%m-%d')
  spec.summary       = 'Da Vinci PDex Test Kit'
  spec.description   = 'Test Kit for the Da Vinci Payer Data Exchange (PDex) FHIR Implementation Guide'
  # spec.homepage      = 'TODO'
  spec.license       = 'Apache-2.0'
  spec.add_runtime_dependency 'inferno_core', '~> 0.4.28'
  spec.add_development_dependency 'database_cleaner-sequel', '~> 1.8'
  spec.add_development_dependency 'factory_bot', '~> 6.1'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'webmock', '~> 3.11'

  # dependent test kits:
  spec.add_runtime_dependency 'us_core_test_kit', '>= 0.6.4'

  spec.required_ruby_version = Gem::Requirement.new('>= 3.1.2')
  # spec.metadata['homepage_uri'] = spec.homepage
  # spec.metadata['source_code_uri'] = 'TODO'
  spec.files = [
    Dir['lib/**/*.rb'],
    Dir['lib/**/*.json'],
    'LICENSE'
  ].flatten

  spec.require_paths = ['lib']
end
