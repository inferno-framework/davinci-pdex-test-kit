module DaVinciPDexTestKit
    class PDexPayerClientSuite < Inferno::TestSuite
      id :pdex_payer_client
      title 'Da Vinci PDex Payer Client Test Suite'
      description %(
        # Da Vinci PDex Payer Client Test Suite

        This suite validates that a payer system can act as a client
        retrieving patient data from another payer system using
        payer to payer exchange as described in the PDex implementation
        guide. Inferno will act as a payer server that the 
        system under test will connect to and retrieve data from.
      )
  
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
  
      # All FHIR validation requsets will use this FHIR validator
      validator do
        url ENV.fetch('VALIDATOR_URL')
      end
    end
  end
  