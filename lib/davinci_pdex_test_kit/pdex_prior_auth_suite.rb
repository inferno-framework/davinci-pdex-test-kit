
module DaVinciPDexTestKit
  class PDexPriorAuthSuite < Inferno::TestSuite
    id :pdex_prior_auth
    title 'PDex STU 2.1 Prior Authorization'

    fhir_resource_validator do
      # TODO 2.1 ig
    end

    input :explanation_of_benefit,
      type: 'textarea',
      title: 'PDex Prior Authorization instance',
      description: 'JSON only'

    group do
      id :pdex_prior_auth_group
      title 'PDex STU 2.1 Prior Authorization'

      test do
        id :pdex_json_validation_test
        title 'JSON Validation'
  
        input :explanation_of_benefit
  
        run do
          assert_valid_json(explanation_of_benefit)
        end
      end
  
      test do
        id :pdex_resource_validation_test
        title 'Explanation Of Benefit Resource Validation'
  
        input :explanation_of_benefit
  
        run do
          assert_valid_resource(resource: FHIR.from_contents(explanation_of_benefit))
        end
      end
  
      test do
        id :pdex_profile_validation_test
        title 'PDex Prior Authorization Profile Validation'
  
        input :explanation_of_benefit
  
        run do
          assert_valid_resource(resource: FHIR.from_contents(explanation_of_benefit), profile_url: 'http://hl7.org/fhir/us/davinci-pdex/StructureDefinition/pdex-priorauthorization')
        end
      end
    end

  end
end
