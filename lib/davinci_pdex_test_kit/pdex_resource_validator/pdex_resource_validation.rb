module DaVinciPDexTestKit
  module PDexResourceValidator

    # Factorized test for resource validation on FHIR R4
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
    # +resource_type+ - *Optional:* FHIR resource type
    # +description+ - *Optional:* Helpful markdown text
    #
    # ==== Required Scratch
    #
    # (none)
    #
    # ==== Notes
    #
    # Skips if no input provided.
    #
    class PDexResourceValidation < Inferno::Test
      id :pdex_resource_validation
      title config.options[:resource_type] ? "#{config.options[:resource_type]} Resource Validation" : 'Resource Validation'
      description config.options[:description]

      input :target

      run do
        omit_if !target
        assert_valid_resource(resource: FHIR.from_contents(target))
      end
    end

  end
end
