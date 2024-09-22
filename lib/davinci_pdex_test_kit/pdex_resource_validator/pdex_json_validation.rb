module DaVinciPDexTestKit
  module PDexResourceValidator

    # Factorized test for JSON validation on PDex v2.1.0 and HRex v1.1.0.
    #
    # ==== Inputs
    #
    # +target+ - *Optional:* JSON text to validate
    #
    # ==== Outputs
    #
    # (none)
    #
    # ==== Required Config
    #
    # (none)
    #
    # ==== Required Scratch
    #
    # (none)
    #
    # ==== Notes
    #
    # Skips if no input provided.
    #
    class PDexJsonValidation < Inferno::Test
      id :pdex_json_validation
      title 'JSON Validation'

      input :target

      run do
        omit_if !target
        assert_valid_json(target)
      end
    end

  end
end
