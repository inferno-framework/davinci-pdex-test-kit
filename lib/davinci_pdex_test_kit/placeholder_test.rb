require_relative 'urls'

module DaVinciPDEXTestKit
  class PDEXClientSubmitMustSupportTest < Inferno::Test
    include URLs

    id :placeholder_start_test
    title 'Client submits claims using the $submit operation to demonstrate coverage of must support elements'
    description %(
      This test allows the client to send $submit requests in addition to any already sent in previous test groups
      for Inferno to evaluate coverage of must support elements.
    )
    input :access_token
    config options: { accepts_multiple_requests: true }

    run do
      wait(
        identifier: access_token,
        message: %(
          The client system may now make multiple $submit requests before continuing. These requests should cumulatively
          demonstrate coverage of all required profiles and all must support elements within those profiles, as
          specified by the DaVince Prior Authorization Support implementation guide.

          For the $submit operation the required profiles include:
          - PAS Request Bundle
          - PAS Claim
          - PAS Claim Update
          - PAS Beneficiary Patient
          - PAS Coverage
          - PAS Encounter
          - PAS Insurer Organization
          - PAS Practitioner
          - PAS PractitionerRole
          - PAS Requestor Organization
          - PAS Subscriber Patient
          - At least one of the following:
            - PAS Medication Request
            - PAS Service Request
            - PAS Device Request
            - PAS Nutrition Order

          Submit PAS requests to `#{submit_url}`, with `:endpoint` replaced with the endpoint you want to reach 
          and [click here](#{resume_pass_url}?token=#{access_token}) when done.
        )
      )
    end
  end
end
