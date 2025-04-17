require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientPractitionerSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_practitioner_clinical_data_request
      title 'Practitioner resources related to the patient matched are gathered'
      description %(
        This test verify that the expected instances of resource type Practitioner
        were fetched by the client.
      )

      def target_resource_type
        :Practitioner
      end
  
      run do
        check_resource_type_fetched_instances(target_resource_type)
      end
    end
  end
end
