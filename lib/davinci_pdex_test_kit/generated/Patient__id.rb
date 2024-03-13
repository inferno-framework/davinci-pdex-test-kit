require_relative '../urls'

module DaVinciPDEXTestKit
  class PDEXPatientClientSubmitMustRequirementTest < Inferno::Test
    include URLs

    id :placeholder_verify_patient_test
    title 'Looks through requests made for an attempt to gather Patient resources'
    description %(
      descriptiondescriptiondescription
    )
    input :access_token

    run do
      requests = load_tagged_requests(SUBMIT_TAG)
      desired_requests = requests.select { |req| req.url.include?("Patient")}
      assert desired_requests.present?, "No requests made for Patient resources"
      assert desired_requests.any? { |req| req.query_parameters["_id"] == "999" }, "No requests filtered by patient"
    end
  end
end
