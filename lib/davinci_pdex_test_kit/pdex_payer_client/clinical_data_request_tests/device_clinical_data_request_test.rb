require_relative '../../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientDeviceSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :device_clinical_data_request_test
    title 'Device resources related to the patient matched are gathered'
    description %(
      This test will look through all returned Device resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:Device].nil?, "No requests made for Device resources"

      assert scratch[:Device].any? {|resource| resource.id = 'pdex-Device'}, "Unable to find expected resource: pdex-Device" 
    end
  end
end
