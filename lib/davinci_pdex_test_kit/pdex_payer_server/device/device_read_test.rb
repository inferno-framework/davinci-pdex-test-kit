require 'us_core_test_kit/read_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class DeviceReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct Device resource from Device read interaction'
      description 'A server SHALL support the Device read interaction.'

      id :pdex_device_read

      def resource_type
        'Device'
      end

      def scratch_resources
        scratch[:device_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
