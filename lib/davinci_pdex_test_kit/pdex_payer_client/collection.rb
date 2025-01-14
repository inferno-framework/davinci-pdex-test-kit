module DaVinciPDexTestKit
  module PDexPayerClient
    SET_TO_BE_GATHERED = {AllergyIntolerance: ['pdex-AllergyIntolerance'],
                          CarePlan: ['pdex-CarePlan'],
                          CareTeam: ['pdex-CareTeam'],
                          Condition: ['pdex-Condition'],
                          Device: ['pdex-Device'],
                          DiagnosticReport: ['pdex-DiagnosticReport'],
                          DocumentReference: ['pdex-DocumentReference'],
                          Encounter: ['pdex-Encounter'],
                          ExplanationOfBenefit: ['pdex-ExplanationOfBenefit'],
                          Goal: ['pdex-Goal'],
                          Immunization: ['pdex-Immunization'],
                          Location: ['pdex-Location'],
                          MedicationDispense: ['pdex-MedicationDispense'],
                          MedicationRequest: ['pdex-MedicationRequest'],
                          Observation: ['pdex-Observation'],
                          Organization: ['pdex-Organization'],
                          Patient: ['999'],
                          Practitioner: ['pdex-Practitioner'],
                          PractitionerRole: ['pdex-PractitionerRole'],
                          Procedure: ['pdex-Procedure']
                          # TODO: What about Provenance?
                        }
  
    SEARCHES_BY_PRIORITY = {AllergyIntolerance: [['patient']],
                            CarePlan: [['category', 'patient']],
                            CareTeam: [['patient', 'status']],
                            Condition: [['category', 'patient'], ['patient']],
                            Device: [['patient', 'type'], ['patient']],
                            DiagnosticReport: [['category', 'date', 'patient'], ['code', 'patient'], ['category', 'patient'], ['patient']],
                            DocumentReference: [['_id'], ['category', 'date', 'patient'], ['patient', 'type'], ['category', 'patient'], ['patient']],
                            Encounter: [['_id'], ['date', 'patient'], ['patient']],
                            ExplanationOfBenefit: [['_id'], ['patient'], ['identifier'], ['_lastUpdated'], ['service-date'], ['type']],
                            Goal: [['patient']],
                            Immunization: [['patient']],
                            Location: [['name'], ['address']],
                            MedicationDispense: [['patient']],
                            MedicationRequest: [['intent', 'patient']],
                            Observation: [['category', 'date', 'patient'], ['code', 'patient'], ['category', 'patient']],
                            Organization: [['name'], ['address']],
                            Patient: [['_id'], ['identifier'], ['birthdate', 'name'], ['gender', 'name'], ['name']],
                            Practitioner: [['identifier'], ['name']],
                            PractitionerRole: [['practitioner'], ['specialty']],
                            Procedure: [['date', 'patient'], ['patient']],
                          }
  end
end
