require_relative '../urls'

module DaVinciPDEXTestKit
  class PDEXAllergyIntoleranceClientSubmitMustRequirementTest < Inferno::Test
    include URLs

    id :placeholder_verify_allergyintolerance_test
    title 'Looks through requests made for an attempt to gather AllergyIntolerance resources'
    description %(
      descriptiondescriptiondescription
    )
    input :access_token

    run do
      requests = load_tagged_requests(SUBMIT_TAG)
      desired_requests = requests.select { |req| req.url.include?("AllergyIntolerance")}
      assert desired_requests.present?, "No requests made for AllergyIntolerance resources"
      assert desired_requests.any? { |req| req.query_parameters["patient"] == "999" }, "No requests filtered by patient"
    end
  end
end
