require_relative 'visual_inspection_and_attestation/must_support'
require_relative 'visual_inspection_and_attestation/receive_must_support'
require_relative 'visual_inspection_and_attestation/provenance'
require_relative 'visual_inspection_and_attestation/authentication'

module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexClientVisualInspectionAndAttestationGroup < Inferno::TestGroup
      id :pdex_client_visual_inspection_and_attestation
      title 'Visual Inspection and Attestation'

      description <<~DESCRIPTION
        Perform visual inspections or attestations to ensure that the Client is conformant to the Da Vinci Payer Data Exchange IG requirements.
      DESCRIPTION

      run_as_group

    test from: :pdex_member_authentication_test
    test from: :pdex_client_must_support_interpretation_test
    test from: :pdex_must_support_sub_element_handling_test
    test from: :pdex_accept_retain_provenance_test
    end
  end
end
