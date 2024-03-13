require_relative '../urls'

module DaVinciPDEXTestKit
  class PDEXDeviceClientSubmitMustRequirementTest < Inferno::Test
    include URLs

    id :placeholder_verify_device_test
    title 'Looks through requests made for an attempt to gather Device resources'
    description %(
      descriptiondescriptiondescription
    )
    input :access_token

    run do
      requests = load_tagged_requests(SUBMIT_TAG)
      desired_requests = requests.select { |req| req.url.include?("Device")}
      assert desired_requests.present?, "No requests made for Device resources"
      assert desired_requests.any? { |req| req.query_parameters["patient"] == "999" }, "No requests filtered by patient"
    end
  end
end
