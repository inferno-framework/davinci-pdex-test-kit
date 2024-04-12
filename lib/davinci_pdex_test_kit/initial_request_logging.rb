module DaVinciPDEXTestKit
  class PDEXInitialRequestLoggingTest < Inferno::Test
    include URLs

    id :initial_request_logging
    title 'Placeholder for showing the requests received and the responses given to each.'
    description %(
      
    )
    input :access_token

    run do
      requests = load_tagged_requests(SUBMIT_TAG)
    end
  end
end
