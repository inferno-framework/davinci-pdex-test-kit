# frozen_string_literal: true

def fixture(filename)
  JSON.parse(File.read(File.expand_path("../fixtures/#{filename}", __dir__)))
end

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

    factory :parameters, class: 'FHIR::Parameters' do
      factory :member_match_request do
        parameter do
          [
            member_patient_parameter,
            consent_parameter,
            coverage_to_match_parameter,
            coverage_to_link_parameter
          ]
        end

        transient do
          member_patient_parameter do
            {
              name: 'MemberPatient',
              resource: fixture('member_patient.fhir.json')
            }
          end
          consent_parameter do
            {
              name: 'Consent',
              resource: fixture('consent.fhir.json')
            }
          end
          coverage_to_match_parameter do
            {
              name: 'CoverageToMatch',
              resource: fixture('coverage_to_match.fhir.json')
            }
          end
          coverage_to_link_parameter do
            {
              name: 'CoverageToLink',
              resource: fixture('coverage_to_link.fhir.json')
            }
          end
        end

        factory :bad_member_match_request do
          parameter { [] }
        end

        factory :member_match_request_without_coverage_to_link do
          parameter do
            [
              member_patient_parameter,
              consent_parameter,
              coverage_to_match_parameter
            ]
          end
        end
      end

      factory :member_match_response do
        parameter do
          [
            {
              "name": "MemberIndentifier",
              "valueIdentifier": {
                "type": {
                  "coding": {
                    "system": "http://terminology.hl7.org/3.1.0/CodeSystem-v2-0203",
                    "code": "MB"
                  }
                },
                "value": "1234-234-1243-12345678901"
              }
            }
          ]
        end
      end
    end

    factory :bundle, class: 'FHIR::Bundle' do
      type { 'collection' }

      factory :search_bundle, aliases: ['empty_search_bundle'] do
        type { 'searchset' }

        factory :patient_search_bundle do
          entry do
            [
              FHIR::Bundle::Entry.new({
                resource: fixture('member_patient.fhir.json')
              })
            ]
          end
        end
      end
    end
  end
end
