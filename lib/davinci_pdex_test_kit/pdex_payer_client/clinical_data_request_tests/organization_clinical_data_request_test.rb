require_relative '../../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientOrganizationSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :organization_clinical_data_request_test
    title 'Organization resources related to the patient matched are gathered'
    description %(
      This test will look through all returned Organization resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      info "scratch keys: #{scratch.keys}"
      skip_if scratch[:Organization].nil?, "No requests made for Organization resources"

      assert scratch[:Organization].any? {|resource| resource.id == 'pdex-Organization'}, "Unable to find expected resource: pdex-Organization" 
    end
  end
end
