require_relative '../urls'

module DaVinciPDEXTestKit
  class PDEXMedicationDispenseClientSubmitMustRequirementTest < Inferno::Test
    include URLs

    id :placeholder_verify_medicationdispense_test
    title 'Looks through requests made for an attempt to gather MedicationDispense resources'
    description %(
      descriptiondescriptiondescription
    )
    input :access_token
    
    run do
      desired_requests = load_tagged_requests(SUBMIT_TAG).select { |req| req.url.include?("MedicationDispense")}
      assert desired_requests.present?, "No requests made for MedicationDispense resources"
      assert desired_requests.any? { |req| req.query_parameters["patient"] == "999" }, "No requests filtered by patient"
    end
  end
end
