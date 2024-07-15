require_relative '../../urls'
module DaVinciPDexTestKit
  class PDexClientSubmitMustSupportTest < Inferno::Test
    include URLs

    id :initial_wait_test
    title 'Client makes clinical data requests'
    description %(
      This test will receive clinical data requests until the user confirms they are done. 
    )
    input :access_token
    config options: { accepts_multiple_requests: true }

    run do
      wait(
        identifier: access_token,
        message: %(
          Access Token: #{access_token} \n
          Submit PDex requests via at least one of the following methods:
          * Single Resource API: `#{submit_url}`, with `:endpoint` replaced with the endpoint you want to reach
          * $everything method: `#{everything_url}`, with `:patient` replaced with the patient you are matching
          * $export method: `#{export_url}`, see workflow process at the [Bulk Data IG](https://hl7.org/fhir/uv/bulkdata/STU2/)
          * $export-poll-status: `#{export_status_url}`, then continue to make reads from the binaries if a payload is delivered
          
          and [click here](#{resume_clinical_data_url}?token=#{access_token}) when done.
        ),
        timeout: 900
      )
    end
  end
end
