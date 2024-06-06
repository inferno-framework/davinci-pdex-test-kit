require_relative '../../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientPractitionerRoleSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :practitionerrole_clinical_data_request_test
    title 'PractitionerRole resources related to the patient matched are gathered'
    description %(
      This test will look through all returned PractitionerRole resources for a specific expected resource related to the matched patient.
    )
    input :access_token


    run do
      info "scratch keys: #{scratch.keys}"
      skip_if scratch[:PractitionerRole].nil?, "No requests made for PractitionerRole resources"

      assert scratch[:PractitionerRole].any? {|resource| resource.id == 'pdex-PractitionerRole'}, "Unable to find expected resource: pdex-PractitionerRole" 
    end
  end
end
