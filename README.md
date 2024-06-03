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
- For client testing: a [sample postman collection](config/PAS%20Test%20Kit%20Client%20Test%20Demo.postman_collection.json)

Detailed instructions can be found in the suite descriptions when the tests
are run, or within this repository for the 
[server](lib/davinci_pdex_test_kit/docs/payer_server_suite_description_v200.md#running-the-tests) and
[client](lib/davinci_pdex_test_kit/docs/payer_client_suite_description_v200.md#running-the-tests).

### ONC Hosted Instance

You can run the PDex test kit via the [ONC Inferno](https://inferno.healthit.gov/test-kits/davinci-pdex/) website by choosing the “Da Vinci Payer Data Exchange (PDex) Test Kit” test kit.

### Local Inferno Instance

- Download the source code from this repository.
- Open a terminal in the directory containing the downloaded code.
- In the terminal, run `setup.sh`.
- In the terminal, run `run.sh`.
- Use a web browser to navigate to `http://localhost`.

In order to simulate responses to clinical data requests, the payer client test suite
relies on a FHIR server. The test kit was written to work with the [Inferno Reference
Server](https://github.com/inferno-framework/inferno-reference-server).  To change the
server the test kit is directed at, in `.env.production`, set FHIR_REFERENCE_SERVER to
the fhir endpoint of the server to be used in proxy.  In the case of Inferno, this is 
`https://inferno-qa.healthit.gov/reference-server/r4`


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

