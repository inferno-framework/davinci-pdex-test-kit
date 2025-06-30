require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientPractitionerRoleSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_practitionerrole_clinical_data_request
      title 'PractitionerRole resources related to the patient matched are gathered'
      description %(
        This test verify that the expected instances of resource type PractitionerRole
        were fetched by the client.
      )

      def target_resource_type
        :PractitionerRole
      end
  
      run do
        check_resource_type_fetched_instances(target_resource_type)
      end
    end
  end
end
