module DaVinciPDexTestKit
    class PDexProviderClientSuite < Inferno::TestSuite
      id :pdex_provider_client
      title 'Da Vinci PDex Provider Client Test Suite'
      description %(
        # Da Vinci PDex Provider Client Test Suite

        This suite validates that a provider system can act as a client
        retrieving patient data from a payer system using
        the APIs described in the PDex implementation
        guide. Inferno will act as a payer server that the 
        system under test will connect to and retrieve data from.
      )

      links [
        {
          label: 'Report Issue',
          url: 'https://github.com/inferno-framework/davinci-pdex-test-kit/issues'
        },
        {
          label: 'Open Source',
          url: 'https://github.com/inferno-framework/davinci-pdex-test-kit'
        },
        {
          label: 'Download',
          url: 'https://github.com/inferno-framework/davinci-pdex-test-kit/releases'
        },
        {
          label: 'Implementation Guide',
          url: 'https://hl7.org/fhir/us/davinci-pdex/STU2/'
        }
      ]
  
      # These inputs will be available to all tests in this suite
      input :url,
            title: 'FHIR Server Base Url'
  
      input :credentials,
            title: 'OAuth Credentials',
            type: :oauth_credentials,
            optional: true
  
      # All FHIR requests in this suite will use this FHIR client
      fhir_client do
        url :url
        oauth_credentials :credentials
      end
  
      # Hl7 Validator Wrapper:
      fhir_resource_validator do
        igs 'hl7.fhir.us.davinci-pdex#2.0.0'
        # hrex 1.0.0 and other dependencies will auto-load

        exclude_message do |message|
          message.message.match?(/\A\S+: \S+: URL value '.*' does not resolve/)
        end

      end
    end
end

