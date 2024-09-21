require_relative 'pdex_resource_validator/pdex_profile_validation_group'

module DaVinciPDexTestKit
  class PDexResourceValidatorSuite < Inferno::TestSuite
    id :pdex_resource_validator
    title 'PDex STU 2.1 Resource Validator'

    fhir_resource_validator do
      igs 'igs/davinci-pdex-2.1.0.tgz'

      cli_context do
        allowExampleUrls true
      end
    end



    group from: :pdex_profile_validation_group,
          id: :pdex_prior_auth_profile_validation_group,
          config: {
            inputs: {
              target: { 
                name: :explanation_of_benefit,
                type: 'textarea',
                title: 'PDex Prior Authorization instance',
                description: 'JSON only',
                optional: true
              }
            },
            options: {
              resource_type: 'ExplanationOfBenefit',
              profile_name: 'PDex Prior Authorization',
              profile_url: 'http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-priorauthorization'
            }
          }

    group from: :pdex_profile_validation_group,
          id: :pdex_multi_member_match_request_profile_validation_group,
          config: {
            inputs: {
              target: { 
                name: :multi_member_match_request,
                type: 'textarea',
                title: 'PDex Multi Member Match Request',
                description: 'JSON only',
                optional: true
              }
            },
            options: {
              resource_type: 'Parameters',
              profile_name: 'PDex Multi Member Match Request',
              profile_url: 'http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-in'
            }
          }

    group from: :pdex_profile_validation_group,
          id: :pdex_multi_member_match_response_profile_validation_group,
          config: {
            inputs: {
              target: { 
                name: :multi_member_match_response,
                type: 'textarea',
                title: 'PDex Multi Member Match Response',
                description: 'JSON only',
                optional: true
              }
            },
            options: {
              resource_type: 'Parameters',
              profile_name: 'PDex Multi Member Match Response',
              profile_url: 'http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-parameters-multi-member-match-bundle-out'
            }
          }


  end
end
