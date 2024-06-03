The Da Vinci PDex Test Kit Payer Client Suite validates the conformance of payer client
systems to the STU 2 version of the HL7® FHIR®
[Da Vinci Payer Data Exchange (PDex) Implementation Guide](https://hl7.org/fhir/us/davinci-pdex/STU2/).

## Scope

These tests are a **DRAFT** intended to allow payer implementers to perform
preliminary checks of their systems against PDex IG requirements and [provide
feedback](https://github.com/inferno-framework/davinci-pdex-test-kit/issues)
on the tests. Future versions of these tests may validate other
requirements and may change the test validation logic.

## Test Methodology

Inferno will simulate a PDex payer server for the client under test to interact with. The client
will be expected to initiate requests to the server and demonstrate its ability to react
to the returned responses. Over the course of these interactions,
Inferno will seek to observe conformant handling of PDex requirements around
[single member payer-to-payer data exchange](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html)
the transfer of member data from an old payer (represented by Infero) to a new payer
(represented by the client under test). This includes
- The ability of the client to complete the payer to payer data exchange workflow by
    - Initiating the request by invoking the `$member-match` operation.
    - Fetching all clinical data available from the old payer (Inferno) on the returned member.
- The ability of the client to handle the full scope of the PDex IG, such as
    - Reacting appropriately to a failed `$member-match` operation invocation.
    - Providing all must support elements on `$member-match` requests.

Because the process by which 
[payer servers identify each other and establish trust](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#mtls-endpoint-discovery)
is [still under active development](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#future-direction-for-discovery-and-registration),
Inferno does not currently facilitate or validate this part of the workflow. 
See the *Quick Start* section below for the specifics of how this test suite approaches authentication.

For further details on limitations of these tests, see the *Testing Limitations* section below.

All requests made by the client will be checked for conformance to the PDex
IG requirements individually and used in aggregate to determine whether
required features and functionality are present. HL7® FHIR® resources are
validated with the Java validator using `tx.fhir.org` as the terminology server.

## Running the Tests

### Quick Start

For Inferno to simulate a server that returns a matching patient and responds to requests
for that patient's data using FHIR read and search APIs or the $export operation,
Inferno only needs to be able to identify when requests come from the client under test.
Inferno piggybacks on the request authentication for this purpose. Testers must provide
a bearer access token that will be provided within the `Authentication` header (`Bearer <token>`) 
on all requests made to Inferno endpoints during the test. Inferno uses this information to 
associate the message with the test session and determine how to respond. How the token
provided to Inferno is generated is up to the tester. 

Note: authentication options for these tests have not been finalized and are subject to change
as the requirements in the PDex IG evolve. If the implemented approach prevents you from using
these tests, please 
[provide feedback](https://github.com/inferno-framework/davinci-pdex-test-kit/issues) so the
limitations can be addressed.

### Postman-based Demo

If you do not have a PDex client but would like to try the tests out, you can use
[this postman collection](https://github.com/inferno-framework/davinci-pdex-test-kit/blob/main/PDEX.postman_collection.json)
to make requests against Inferno for these tests. To use the Postman demo on this test session

1. Download the [collection](https://github.com/inferno-framework/davinci-pdex-test-kit/blob/main/PDEX.postman_collection.json) and import it into [Postman](https://www.postman.com/downloads/).
2. Select the `PDex Payer Client Postman Demo` from the preset dropdown in the upper left.
3. Click `Run All Tests` button in the upper right and click the `Submit` button in the dialog
  that appears.
4. When a `User Action Required` dialog will appear requesting a `$member-match` request be made, 
   use Postman to send the `$member-match` request found in the `$member-match Requests` folder.
5. When a new `User Action Required` dialog will appear requesting clinical data requests be made,
   use Postman to send some or all of the requests in the `Clinical Data Requests` folder and click
   on the link in the dialog when done. If not all the requests are made, the test will not pass 
   because the test requires that all available data be accessed.
6. When a third `User Action Required` requesting additional `$member-match` requests be made
   demonstrating coverage of all must support elements on `$member-match` submissions, use Postman to send any or all of the requests found in the `$member-match Requests` folder. If only the 
   `$member-match missing CoverageToMatch` is sent, then the test will fail due to missing examples.

The tests will complete and the results made available for review.

## Testing Limitations

The PDex IG is under active development and the IG authors intend to change the approach to the
workflows included within future versions of the IG. In particular the payer to payer workflow
will move from a single-patient workflow to a multi-patient workflow. This test suite focuses on
validating the high-level payer to payer workflow and the ability of clients to use the current
specification to access member data, without doing detailed validation of the mechanisms, 
including authentication and trust establishment, because those details are likely to change 
in future versions of the PDex specification.