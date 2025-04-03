# Da Vinci Payer Data Exchange (PDex) v2.0.0 Test Kit

[Da Vinci Payer Data Exchange (PDex) FHIR
Implementation Guide](https://hl7.org/fhir/us/davinci-pdex/).

The Da Vinci Payer Data Exchange (PDex) STU 2.0.0 Test Kit validates the 
conformance of systems to the 
[PDex STU 2.0.0 FHIR IG](https://hl7.org/fhir/us/davinci-pdex/). 
The test kit includes suites targeting the following actors from the specification:

- **Payer Servers**: Inferno will act as a client and make a series of
  requests to the server under test simulating a new payer's request 
  to access member clinical data from an old payer using the payer to payer workflow.
- **Payer Clients**: Inferno will act as an old payer server that contains member information
  that the client under test would like to access using the payer to payer workflow.
  Inferno will wait for the client to make requests and respond appropriately
  to them.

In each case, content provided by the system under test will be checked individually
for conformance and in aggregate to determine that the full set of features is
supported.

This test kit is [open source](#license) and freely available for use or
adoption by the health IT community including EHR vendors, health app
developers, and testing labs. It is built using the [Inferno
Framework](https://inferno-framework.github.io/). The Inferno Framework is
designed for reuse and aims to make it easier to build test kits for any
FHIR-based data exchange.

## Status

These tests are a **DRAFT** intended to allow PDex implementers to perform 
preliminary checks of their implementations against PDex IG requirements and provide 
feedback on the tests. Future versions of these tests may validate other 
requirements and may change how these are tested.

## Test Scope and Limitations

Neither the server nor client test suite included test the full scope of the PDex IG.
This is because the PDex IG is under active development and the IG authors intend to 
change the approach to the workflows included within future versions of the IG. 
In particular 
- The payer to payer workflow will move from a single-patient workflow to a multi-patient workflow.
- The payer to payer discovery and trust mechanisms will be updated.
- The payer to provider workflow will change to no longer use CDS Hooks.

Due to these expected changes, this test kit focuses on validating the high-level 
payer to payer workflow from both the client and server perspective under the expectation
that the broad need of payers to exchange data will remain, but the details are
expected to change.

## How to Run

Use either of the following methods to run the suites within this test kit.
If you would like to try out the tests but don’t have a PDex implementation, 
the test home pages include instructions for trying out the tests, including

- For server testing: a [public reference implementation](https://prior-auth.davinci.hl7.org/fhir)
  ([code on github](https://github.com/HL7-DaVinci/prior-auth))
- For client testing: a [sample postman collection](PDEX.postman_collection.json)

Detailed instructions can be found in the suite descriptions when the tests
are run or within this repository for the 
[server](lib/davinci_pdex_test_kit/docs/payer_server_suite_description_v200.md#running-the-tests) and
[client](lib/davinci_pdex_test_kit/docs/payer_client_suite_description_v200.md#running-the-tests).

### ONC Hosted Instance

You can run the PDex test kit via the [ONC Inferno](https://inferno.healthit.gov/test-kits/davinci-pdex/) website by choosing the “Da Vinci Payer Data Exchange (PDex) Test Kit” test kit.

### Local Inferno Instance

- Download the source code from this repository.
- [Start or identify](#fhir-server-simulation-for-the-client-suite) 
  an Inferno Reference Server instance for Inferno to use for simulation (only needed if
  planning to run the Client test suite).
- Open a terminal in the directory containing the downloaded code.
- In the terminal, run `setup.sh`.
- In the terminal, run `run.sh`.
- Use a web browser to navigate to `http://localhost`.

## FHIR Server Simulation for the Client Suite

The PDex client test suite needs to be able to return responses to FHIR read and search APIs.
These responses can be complex and so the suite relies on a full FHIR server to provide 
responses for it to provide back to systems under test. The test kit was written to work 
with the [Inferno Reference Server](https://github.com/inferno-framework/inferno-reference-server)

- loaded with [patient 999](https://github.com/inferno-framework/inferno-reference-server/blob/main/resources/pdex_bundle_patient_999.json) and an [associated group](https://github.com/inferno-framework/inferno-reference-server/blob/main/resources/pdex_proxy_group_patient_999.json)
- accepting bearer token `SAMPLE_TOKEN` for read access.

### Simulation Server Configuration For Local Test Kit Execution

The test kit can be configured to point to either a local instance of the reference server or
to a public instance. The location of the The following are valid configuration approaches:

1. Point to a public instance of the Inferno reference server at either 
   `https://inferno.healthit.gov/reference-server/r4/` or
   `https://inferno-qa.healthit.gov/reference-server/r4/`: update the `FHIR_REFERENCE_SERVER`
   environment variable in the appropriate environment file (`.evn.production` when running
   in docker [as above](#local-inferno-instance), or `env.development` when 
   [running the test kit in Ruby](#development)).
2. Run a local instance of the Inferno Reference Server, either 
   [with docker](https://github.com/inferno-framework/inferno-reference-server?tab=readme-ov-file#running-with-docker) 
   or [without docker](https://github.com/inferno-framework/inferno-reference-server?tab=readme-ov-file#running-without-docker) 
   (NOTE: this decision can be made independently from whether to run the test kit with 
   docker or using Ruby).

## Running Server Tests and Client Tests against each other

A preset has been provided if you would like to run the test kits against each other.  To do so:
1. Begin each test suite in separate windows.
2. Select the "PDex Payer Server Preset for Client Tests" preset in the Server Suite.
3. Select "Run All Tests" for both kits.  Input the same access token for both, but do not click submit.
4. Begin the Client tests by clicking submit.  It will now await a member-match to begin the workflow.
5. Begin the Server tests by clicking submit.  It will send a member-match request to begin the workflow.
6. Once a member-match request is received, the client tests will begin awaiting clinical data requests.  The server tests will automatically begin sending them.  Once the Server tests have reached the second group, you may attest in the client that clinical data requests are over.
7. Let both test kits finish, attesting in client side that member-match's have all been received after Server group 2.1 completes. The tests are not expected to pass at this time.

Note that there is a currently a race condition that means that the client test may fail to respond to
some server test suite requests. As a work-around, run the server test suite a second time while the
client is waiting for clinical data requests during test 1.2.

## Server Bulk Export Test Demonstration

These tests require read-write access to FHIR server with `Patient/$export` enabled, or with permissions to those actions assigned to a Bulk Data Authorization Access Token. To view an example run of these tests:
1. Make a local clone of the [Inferno Reference Server](https://github.com/inferno-framework/inferno-reference-server/).
2. Enable read-write mode by adding `READ_ONLY=false` to the environment of the fhir service in docker-compose.yml.
3. Run the server with `docker compose up`
4. Begin the PDex Payer Server Test Suite, select test 1.4 Bulk $export, and run it with the inputs:
  + FHIR Server Base URL: `http://127.0.0.1:8080/reference-server/r4`
  + Patient ID: `85`
  + Bulk Data Authorization Access Token: `SAMPLE_TOKEN`
  + Export Times Out after: `600`

## Providing Feedback and Reporting Issues

We welcome feedback on the tests, including but not limited to the following areas:
- Validation logic, such as potential bugs, lax checks, and unexpected failures.
- Requirements coverage, such as requirements that have been missed and tests that necessitate features that the IG does not require.
- User experience, such as confusing or missing information in the test UI.

Please report any issues with this set of tests in the issues section of this repository.

## Development

To make updates and additions to this test kit, see the 
[Inferno Framework Documentation](https://inferno-framework.github.io/docs/),
particularly the instructions on 
[development with Ruby](https://inferno-framework.github.io/docs/getting-started/#development-with-ruby).

## License

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

