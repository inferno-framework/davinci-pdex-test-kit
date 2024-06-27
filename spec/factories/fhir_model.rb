# frozen_string_literal: true

FactoryBot.define do
  factory :fhir_model, class: 'FHIR::Model' do
    initialize_with { new(**attributes) }
    skip_create

    factory :capability_statement, class: 'FHIR::CapabilityStatement' do
      status { 'active' }
      date { Time.now.strftime('%Y-%m-%d') }
      kind { 'instance' }
      implementation { {description: 'TEST DUMMY'} }
      fhirVersion { '4.0.1' }
      format { %w[json] }
      rest { [{mode: 'server', resource: resource}] }

      transient do
        resource { [] }
      end

      factory :capability_statement_with_patient_resource do
        transient do
          resource do
            [
              {
                type: 'Patient'
              }
            ]
          end
        end
      end

      factory :capability_statement_with_patient_member_match do
        transient do
          resource do
            [
              {
                type: 'Patient',
                operation: [
                  {
                    name: 'member-match',
                    definition: 'http://hl7.org/fhir/us/davinci-hrex/OperationDefinition/member-match'
                  }
                ]
              }
            ]
          end
        end
      end

      factory :capability_statement_with_bad_member_match do
        transient do
          resource do
            [
              {
                type: 'Observation',
                operation: [
                  {
                    name: 'member-match',
                    definition: 'http://hl7.org/fhir/us/davinci-hrex/OperationDefinition/member-match'
                  }
                ]
              }
            ]
          end
        end
      end

    end
  end
end
