require_relative '../urls'

module DaVinciPDexTestKit
  class PDexMustSupportDefinedByHRexTest < Inferno::Test
    include PDexPayerServer::URLs

    title 'Uses HRex Must Support definitions for HRex profiles'

    description <<~DESCRIPTION
      The Health IT Module applies the definition of "Must Support" as defined
      by the Da Vinci HRex Implementation Guide for all HRex profiles referenced in PDex.
    DESCRIPTION

    id :pdex_must_support_defined_by_hrex_test

    verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@5'

    run do
      identifier = SecureRandom.hex(32)

      wait(
        identifier:,
        message: <<~MESSAGE
          The developer of the Health IT Module attests that the system applies the definition
          of "Must Support" as defined by the Da Vinci HRex Implementation Guide for all
          HRex profiles referenced in PDex.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.
          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
        MESSAGE
      )
    end
  end
end
