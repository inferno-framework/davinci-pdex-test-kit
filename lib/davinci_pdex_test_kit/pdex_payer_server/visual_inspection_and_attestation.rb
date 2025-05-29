require_relative 'visual_inspection_and_attestation/bulk_data_transmission_restrictions'
require_relative 'visual_inspection_and_attestation/consent_requirements'
require_relative 'visual_inspection_and_attestation/prior_authorization_decisions'
require_relative 'visual_inspection_and_attestation/payer_consent_compliance'
require_relative 'visual_inspection_and_attestation/licensing'
require_relative 'visual_inspection_and_attestation/hrex_must_support'
require_relative 'visual_inspection_and_attestation/member_auth'
require_relative 'visual_inspection_and_attestation/provenance_records'
require_relative 'visual_inspection_and_attestation/read_and_search_hrex'
require_relative 'visual_inspection_and_attestation/resources_in_capability_statement'
require_relative 'visual_inspection_and_attestation/mtls'
require_relative 'visual_inspection_and_attestation/consent_failure'

module DaVinciPDexTestKit
  class PDexServerVisualInspectionAndAttestationGroup < Inferno::TestGroup
    id :pdex_server_visual_inspection_and_attestation

    title 'Visual Inspection and Attestation'

    description <<~DESCRIPTION
      Perform visual inspections or attestations to ensure that the Server is conformant to the Da Vinci Payer Data Exchange IG requirements.
    DESCRIPTION

    run_as_group

    test from: :pdex_licensing_test
    test from: :pdex_capability_statement_declaration_test
    test from: :pdex_must_support_defined_by_hrex_test
    test from: :pdex_coverage_interaction_support_test
    test from: :pdex_provenance_test
    test from: :pdex_prior_authorization_decisions_test
    test from: :pdex_consent_requirements_test
    test from: :pdex_payer_consent_compliance_test
    test from: :pdex_bulk_data_transmission_restrictions_test
    test from: :pdex_member_authorized_exchange_test
    test from: :pdex_payer_to_payer_mtls
    test from: :pdex_member_match_consent_failure_test
  end
end
