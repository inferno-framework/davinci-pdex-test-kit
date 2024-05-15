require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientOrganizationSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :organization_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather Organization resources related to the patient matched'
    description %(
      This test will look through all returned Organization resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      skip_if scratch[:Organization].nil?, "No requests made for Organization resources"

      assert scratch[:Organization].any? {|resource| resource.id = 'pdex-Organization'}, "Unable to find expected resource: pdex-Organization" 
    end
  end
end
