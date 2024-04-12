module DaVinciPDEXTestKit
  SET_TO_BE_GATHERED = {Patient: ['999'], Encounter: ['pdex-encounter']}
  SEARCHES_BY_PRIORITY = {AllergyIntolerance: [['patient']],
                          CarePlan: [['patient', 'category']],
                          CareTeam: [['patient', 'status']],
                          Condition: [['patient', 'category'], ['patient']],
                          Device: [['patient', 'type'], ['patient']],
                          DiagnosticReport: [['patient', 'category', 'date'], ['patient', 'code'], ['patient', 'category'], ['patient']],
                          DocumentReference: [['_id'], ['patient', 'category', 'date'], ['patient', 'type'], ['patient', 'category'], ['patient']],
                          Encounter: [['_id'], ['patient', 'date'], ['patient']],
                          ExplanationOfBenefit: [['_id'], ['patient'], ['identifier'], ['_lastUpdated'], ['service-date'], ['type']],
                          Goal: [['patient']],
                          Immunization: [['patient']],
                          Location: [['name'], ['address']],
                          MedicationDispense: [['patient']],
                          MedicationRequest: [['patient', 'intent']],
                          Observation: [['patient', 'category', 'date'], ['patient', 'code'], ['patient', 'category']],
                          Organization: [['name'], ['address']],
                          Patient: [['_id'], ['identifier'], ['birthdate', 'name'], ['gender', 'name'], ['name']],
                          Practitioner: [['identifier'], ['name']],
                          PractitionerRole: [['practitioner'], ['specialty']],
                          Procedure: [['patient', 'date'], ['patient']],
                        }
end