require 'us_core_test_kit/read_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class ProvenanceReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Provenance resource from Provenance read interaction'
      description 'A server SHALL support the Provenance read interaction.'

      id :pdex_provenance_read

      def resource_type
        'Provenance'
      end

      def scratch_resources
        scratch[:provenance_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
