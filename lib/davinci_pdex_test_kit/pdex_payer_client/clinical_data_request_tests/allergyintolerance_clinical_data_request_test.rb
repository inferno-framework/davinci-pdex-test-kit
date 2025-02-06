require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientAllergyIntoleranceSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_allergyintolerance_clinical_data_request_test
      title 'AllergyIntolerance resources related to the patient matched are gathered'
      description %(
        This test verify that the expected instances of resource type AllergyIntollerance
        were fetched by the client.
      )
      input :access_token

      def target_resource_type
        :AllergyIntolerance
      end
  
      run do
        check_resource_type_fetched_instances(target_resource_type)
      end
    end
  end
end
