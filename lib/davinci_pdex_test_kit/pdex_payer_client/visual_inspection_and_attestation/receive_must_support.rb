module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexMustSupportSubElementHandlingTest < Inferno::Test
      title 'Accepts Must Support elements without error'

      description <<~DESCRIPTION
        The Health IT Module ensures that it can accept sub-elements marked Must Support
        without generating errors — unless those sub-elements belong to a parent element
        that has a minimum cardinality of 0 and no Must Support flag.
      DESCRIPTION

      id :pdex_must_support_sub_element_handling_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@53'

      run do
        identifier = SecureRandom.hex(32)

        wait(
          identifier:,
          message: <<~MESSAGE
            The developer of the Health IT Module attests that the Health IT System can accept sub-elements marked Must Support
            without generating errors — unless those sub-elements belong to a parent element
            that has a minimum cardinality of 0 and no Must Support flag.

            [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.
            [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
          MESSAGE
        )
      end
    end
  end
end
