require_relative '../urls'
require_relative '../client_validation_test.rb'

module DaVinciPDexTestKit
  class PDexClientPractitionerRoleSubmitClinicalDataRequestTest < Inferno::Test
    include URLs
    include DaVinciPDexTestKit::ClientValidationTest

    id :practitionerrole_clinical_data_request_test
    title 'Looks through requests made for an attempt to gather PractitionerRole resources related to the patient matched'
    description %(
      This test will look through all returned PractitionerRole resources for an expected resource related to the matched patient.
    )
    input :access_token


    run do
      requests = scratch["PractitionerRoleRequests".to_sym]
      skip_if scratch[:PractitionerRole].nil?, "No requests made for PractitionerRole resources"

      assert scratch[:PractitionerRole].any? {|resource| resource.id = 'pdex-PractitionerRole'}, "Unable to find expected resource: pdex-PractitionerRole" 
    end
  end
end
