require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientEncounterSubmitClinicalDataRequestTest < Inferno::Test
      include ClientValidationTest
  
      id :pdex_encounter_clinical_data_request
      title 'Encounter resources related to the patient matched are gathered'
      description %(
        This test verify that the expected instances of resource type Encounter
        were fetched by the client.
      )

      def target_resource_type
        :Encounter
      end
  
      run do
        check_resource_type_fetched_instances(target_resource_type)
      end
    end
  end
end
