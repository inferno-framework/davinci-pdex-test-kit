module DaVinciPDexTestKit
  module PDexProfileValidator

    # Factorized test for profile validation on PDex v2.1.0 and HRex v1.1.0.
    #
    # ==== Inputs
    #
    # +target+ - *Optional:* string to convert into FHIR Model and validate
    #
    # ==== Outputs
    #
    # (none)
    #
    # ==== Required Config
    #
    # +profile_name+ - *Optional:* Humanized name for title
    # +profile_url+ - Canonical URL
    # +description+ - *Optional:* Helpful markdown text, i.e: documentation URL
    # + 
    #
    # ==== Required Scratch
    #
    # (none)
    #
    # ==== Notes
    #
    # Skips if no input provided.
    #
    class PDexProfileValidation < Inferno::Test
      id :pdex_profile_validation
      title config.options[:profile_name] ? "#{config.options[:profile_name]} Profile Validation" : 'Profile Validation'
      description config.options[:description]

      input :target

      run do
        omit_if !target
        assert_valid_resource(resource: FHIR.from_contents(target), profile_url: config.options[:profile_url])
      end
    end

  end
end
