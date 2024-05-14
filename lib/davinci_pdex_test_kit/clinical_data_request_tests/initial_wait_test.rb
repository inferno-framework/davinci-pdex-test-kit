require_relative '../urls'
module DaVinciPDexTestKit
  class PDexClientSubmitMustSupportTest < Inferno::Test
    include URLs

    id :initial_wait_test
    title 'Client makes requests that capture an entire patient'
    description %(
      
    )
    input :access_token
    config options: { accepts_multiple_requests: true }

    run do
      wait(
        identifier: access_token,
        message: %(
          Submit PDex requests to `#{submit_url}`, with `:endpoint` replaced with the endpoint you want to reach 
          and [click here](#{resume_clinical_data_url}?token=#{access_token}) when done.
        )
      )
    end
  end
end
