require 'us_core_test_kit/must_support_test'
require 'us_core_test_kit/generator/group_metadata'

module DaVinciPDexTestKit
  module PDexPayerServer
    class DeviceMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the Device resources returned'
      description %(
        PDex Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the PDex Server Capability
        Statement. This test will look through the Device resources
        found previously for the following must support elements:

        * Device.distinctIdentifier
        * Device.expirationDate
        * Device.lotNumber
        * Device.patient
        * Device.serialNumber
        * Device.status
        * Device.type
        * Device.udiCarrier
        * Device.udiCarrier.carrierAIDC
        * Device.udiCarrier.carrierHRF
        * Device.udiCarrier.deviceIdentifier
        * Device.url
      )

      id :pdex_device_must_support

      def resource_type
        'Device'
      end

      def self.metadata
        @metadata ||= USCoreTestKit::Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'),
                                                                                 aliases: true))
      end

      def scratch_resources
        scratch[:device_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
