
module DaVinciPDexTestKit
  class PDexPriorAuthSuite < Inferno::TestSuite
    id :pdex_prior_auth
    title 'PDex STU 2.1 Prior Authorization'

    fhir_resource_validator do
      igs 'igs/davinci-pdex-2.1.0.tgz'


      cli_context do
          allowExampleUrls true
      end
    end

    input :explanation_of_benefit,
      type: 'textarea',
      title: 'PDex Prior Authorization instance',
      description: 'JSON only',
      optional: true

    group do
      id :pdex_prior_auth_group
      title 'PDex STU 2.1 Prior Authorization'

      test do
        id :pdex_json_validation_test
        title 'JSON Validation'
  
        input :explanation_of_benefit
  
        run do
          skip_if !explanation_of_benefit
          assert_valid_json(explanation_of_benefit)
        end
      end
  
      test do
        id :pdex_resource_validation_test
        title 'Explanation Of Benefit Resource Validation'
  
        input :explanation_of_benefit
  
        run do
          skip_if !explanation_of_benefit
          assert_valid_resource(resource: FHIR.from_contents(explanation_of_benefit))
        end
      end
  
      test do
        id :pdex_profile_validation_test
        title 'PDex Prior Authorization Profile Validation'
  
        input :explanation_of_benefit
  
        run do
          skip_if !explanation_of_benefit
          assert_valid_resource(resource: FHIR.from_contents(explanation_of_benefit), profile_url: 'http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-priorauthorization')
        end
      end
    end

    group do
      id :pdex_multi_member_match_request_group
      title 'PDex STU 2.1 Multi Member Match Request'

      input :multi_member_match_request,
        type: 'textarea',
        title: 'PDex Multi Member Match Request instance',
        optional: true

      test do
        title 'Parameters Resource Validation'

        input :multi_member_match_request

        run do
          skip_if !multi_member_match_request
          assert_valid_resource(resource: FHIR.from_contents(multi_member_match_request))
        end
      end

      test do
        title 'Member Match Request Profile Validation'

        input :multi_member_match_request

        run do
          skip_if !multi_member_match_request
          assert_valid_resource(resource: FHIR.from_contents(multi_member_match_request), profile_url: 'http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-parameters-member-match-in')
        end
      end
    end


  end
end
