require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientDeviceSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_device_clinical_data_request
      title 'Device resources related to the patient matched are gathered'
      description %(
        This test verify that the expected instances of resource type Device
        were fetched by the client.
      )

      def target_resource_type
        :Device
      end
  
      run do
        check_resource_type_fetched_instances(target_resource_type)
      end
    end
  end
end
