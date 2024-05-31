require_relative '../client_validation_test.rb'
module DaVinciPDexTestKit
  class PDexClientScratchStorage < Inferno::Test
    include DaVinciPDexTestKit::ClientValidationTest

    id :initial_scratch_storing
    title 'Client makes clinical data requests that capture an entire patient'
    description %(
      This test organizes the received requests in order to validate all expected specific resources were returned
    )
    input :access_token

    run do
      previous_clinical_data_request_resources.each do |request, resources|
        resources.each do |resource|
          scratch[resource.resourceType.to_sym] ||= []
          scratch[resource.resourceType.to_sym] |= [resource]
        end
      end
      if export_request
        info "Attempted an $export request"
        export_resources.each do |resource|
          scratch[resource.resourceType.to_sym] ||= []
          scratch[resource.resourceType.to_sym] |= [resource]
        end
      else
        info "Found export request, but was unable to read content-location for export payload.  It may not have had enough time to build"
      end
      if everything_request
        info "Attempted an $everything request"
      end
    end
  end
end
