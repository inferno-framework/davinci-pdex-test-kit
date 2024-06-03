The Da Vinci PDex Test Kit Payer Server Suite validates the conformance of payer server
systems to the STU 2 version of the HL7® FHIR®
[Da Vinci Payer Data Exchange (PDex) Implementation Guide](https://hl7.org/fhir/us/davinci-pdex/STU2/).

## Scope

These tests are a **DRAFT** intended to allow payer implementers to perform
preliminary checks of their systems against PDex IG requirements and [provide
feedback](https://github.com/inferno-framework/davinci-pdex-test-kit/issues)
on the tests. Future versions of these tests may validate other
requirements and may change the test validation logic.

## Test Methodology

Inferno will simulate a PDex payer client for the server under test to interact with. The server
will be expected to respond to requests made by Inferno. Over the course of these interactions,
Inferno will seek to observe conformant handling of PDex requirements around
[single member payer-to-payer data exchange](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html)
the transfer of member data from an old payer (represented by the server under test) to a new payer
(represented by Inferno). This includes
- The ability of the server to complete the payer to payer data exchange workflow by
    - Responding successfully to invocations of the `$member-match` operation.
    - Returning requested clinical data for the matched member.
- The ability of the server to handle the full scope of the PDex IG, such as
    - Support PDex and US Core 3.1.1 search and read APIs, profile, and must support requirements
    - Produce failure responses to `$member-match` requests

Because the process by which 
[payer servers identify each other and establish trust](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#mtls-endpoint-discovery)
is [still under active development](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#future-direction-for-discovery-and-registration),
Inferno does not currently facilitate or validate this part of the workflow. 
See the *Authentication* section below for the specifics of how this test suite approaches authentication.

Note additionally that because the member matching logic is not specified within the implementation
guide and Inferno will not know ahead of time the contents of server under test, testers are required
to provide request bodies for `$member-match` invocations that they know will return the outcome
expected by the test. Inferno will validate that these request bodies conform to the [`$member-match`
input parameter requirements](https://hl7.org/fhir/us/davinci-hrex/StructureDefinition-hrex-parameters-member-match-in.html).

For further details on limitations of these tests, see the *Testing Limitations* section below.

All tester-provided requests and responses returned by the server will be checked 
for conformance to the PDex IG requirements individually and used in aggregate to determine whether
required features and functionality are present. HL7® FHIR® resources are
validated with the Java validator using `tx.fhir.org` as the terminology server.

## Running the Tests

### Quick Start

Execution of these tests require a significant amount of tester input in the
form of requests that Inferno will make against the server under test.

If you would like to try out the tests using examples from the IG against the
[PDex reference server hosted on FHIR Foundry](https://pdex-server.davinci.hl7.org/fhir), you can do so by 
1. Selecting the *PDex Payer Server Preset for FHIR Foundry RI* option from the Preset dropdown in the upper left
2. Clicking the *Run All Tests* button in the upper right
3. Clicking the *Submit* button at the bottom of the input dialog

Note that the reference implementation is not expected to pass the tests at this time.

You can run these tests using your own server by updating the "FHIR Server Endpoint URL" and 
"OAuth Credentials" inputs. Additional inputs to update to values specific to your implementation 
include:
- "Member Match Request for one match"
- "Member Match Request for no matches"
- "Member Match Request for multiple matches"
- "Patient IDs"

Details on these inputs can be found below.

## Test Configuration Details

The details provided here supplement the documentation of individual fields in the input dialog
that appears when initiating a test run.

### Server identification

Requests will be made to the `/Patient/$member-match` and clinical data access endpoints under 
the url provided in the "FHIR Server Endpoint URL" field.

### Authentication

The PDex payer to payer workflow contains a
[detailed approach to endpoint discovery](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#mtls-endpoint-discovery),
[trust](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#trust-framework), and
[scoped data access](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#data-retrieval-methods).
However, the IG also states that significant parts of the IGs that are [expected to change](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#future-direction-for-discovery-and-registration).
Therefore, the tests currently assume that the server under test can provide a bearer token that Inferno
will submit with all requests. If this simplified approach prevents you from using these tests, please 
[provide feedback](https://github.com/inferno-framework/davinci-pdex-test-kit/issues) so the
limitations can be addressed.

### $member-match Request Bodies

Three inputs for the test suite ask the tester to provide bodies for `$member-match` submissions:
- "Member Match Request for one match"
- "Member Match Request for no matches"
- "Member Match Request for multiple matches"

In each case, provide the raw json for the body that Inferno will use to invoke the server's
`$member-match` operation that will elicit an appropriate response.

### Complete Patients

Inferno will test that the server's FHIR API allows for access to all clinical data covered by
the PDex IG and the US Core IG that it inherits from. In order to do so, it needs the id of 
one or more patients in the "Patient IDs" input. It will use the patient id or ids provided
to fetch clinical data and check that the required profiles and must support elements are represented.

## Testing Limitations

The PDex IG is under active development and the IG authors intend to change the approach to the
workflows included within future versions of the IG. In particular the payer to payer workflow
will move from a single-patient workflow to a multi-patient workflow. This test suite focuses on
validating the high-level payer to payer workflow and the ability of servers to use the current
specification to make member data available, without doing detailed validation of the mechanisms, 
including authentication and trust establishment, because those details are likely to change 
in future versions of the PDex specification.