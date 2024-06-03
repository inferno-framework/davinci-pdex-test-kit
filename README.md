# Da Vinci Payer Data Exchange (PDex) Test Kit

This is an [Inferno](https://github.com/inferno-community/inferno-core) 
test kit for the [Da Vinci Payer Data Exchange (PDex) FHIR
Implementation Guide](https://hl7.org/fhir/us/davinci-pdex/).

## Documentation
- [Inferno documentation](https://inferno-framework.github.io/inferno-core/)
- [Ruby API documentation](https://inferno-framework.github.io/inferno-core/docs)
- [JSON API documentation](https://inferno-framework.github.io/inferno-core/api-docs)

## PDEX Client Tests
- Requests are forwarded to a local server.  This is found in `lib/davinci_pdex_test_kit/mock_server.rb`'s
 `server_proxy`
- Postman collection exists for mocking the client, at `PDEX-mock-client.postman_collection.json`
- Tests are organized into two categories, a workflow test group, and a must support test group
- - Workflow test group - Tests member-match requests, returns an identifier, and checks that the client attempts to gather all resources related to the matched patient
- - Must Support test group - Tests that all Must Support elements of the member-match-input profile are covered by any of the received member-match requests

## Running Server Tests and Client Tests against each other
A preset has been provided if you would like to run the test kits against each other.  To do so:
1. Begin each test suite in separate windows.
2. Select the "PDex Payer Server Preset for Client Tests" preset in the Server Suite.
3. Select "Run All Tests" for both kits.  Input the same access token for both, but do not click submit.
4. Begin the Client tests by clicking submit.  It will now await a member-match to begin the workflow.
5. Begin the Server tests by clicking submit.  It will send a member-match request to begin the workflow.
6. Once a member-match request is received, the client tests will begin awaiting clinical data requests.  The server tests will automatically begin sending them.  Once the Server tests have reached the second group, you may attest in the client that clinical data requests are over.
7. Let both test kits finish, attesting in client side that member-match's have all been received after Server group 2.1 completes.

## Instructions for Developing tests

To get started writing tests, clone this repo/Click "Use this template" on
github. Refer to the Inferno documentation for information about [setting up
your development environment and running
Inferno](https://inferno-framework.github.io/inferno-core/getting-started.html#getting-started-for-inferno-test-writers).

## Example Inferno test kits

- https://github.com/inferno-community/ips-test-kit
- https://github.com/inferno-community/shc-vaccination-test-kit

## License
Copyright 2022 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

## Trademark Notice

HL7, FHIR and the FHIR [FLAME DESIGN] are the registered trademarks of Health
Level Seven International and their use does not constitute endorsement by HL7.
