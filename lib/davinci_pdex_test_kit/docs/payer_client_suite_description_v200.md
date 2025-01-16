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
    - Initiating the workflow by invoking the `$member-match` operation.
    - Fetching the returned member's full [member health
      history](https://hl7.org/fhir/us/davinci-pdex/STU2/introduction.html#member-health-history)
      from Inferno's simulated fhir server. In order to pass these tests, a client must 
      demonstrate their ability to retrieve instances of each profile that is part of the
      member health history.

Inferno's simulated PDex FHIR server contains a patient with the following demographics which
will always be returned in `$member-match` responses while clients are demonstrating the
workflow. If systems want to create a similar patient in their system to use in the tests,
the demographics are:
- **Last Name**: Dexter882
- **Given Name**: Patty408
- **Identifier**: 99999 from system http://github.com/inferno-framework/target-payer/identifiers/member
- **Gender**: female
- **Birth Date**: 1980-01-15

This patient contains examples instances for most of the profiles in the PDex [member health
history](https://hl7.org/fhir/us/davinci-pdex/STU2/introduction.html#member-health-history),
so accessing the complete set of data on that patient starting from the `$member-match`
response allows systems to demonstrate the required capabilities.

Because the process by which 
[payer servers identify each other and establish trust](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#mtls-endpoint-discovery)
is [still under active development](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#future-direction-for-discovery-and-registration),
Inferno does not currently facilitate or validate this part of the workflow. 
See the *Quick Start* section below for the specifics of how this test suite approaches auth.

For further details on limitations of these tests, see the *Testing Limitations* section below.

All requests made by the client will be checked for conformance to the PDex
IG requirements individually and used in aggregate to determine whether
required features and functionality are present. HL7® FHIR® resources are
validated with the Java validator using `tx.fhir.org` as the terminology server.

## Running the Tests

### Quick Start

For Inferno to simulate a server that returns a matching patient and responds to requests
for that patient's data using FHIR read and search APIs, Inferno only needs to be able to
identify when requests come from the client under test. Inferno piggybacks on the request 
authentication for this purpose. Testers must provide a bearer access token that will be 
provided within the `Authorization` header (`Bearer <token>`) on all requests made to 
Inferno endpoints during the test. Inferno uses this information to associate the message
with the test session and determine how to respond. How the token provided to Inferno is 
generated is up to the tester. 

Note: auth options for these tests have not been finalized and are subject to change
as the requirements in the PDex IG evolve. If the implemented approach prevents you from using
these tests, please 
[provide feedback](https://github.com/inferno-framework/davinci-pdex-test-kit/issues) so the
limitations can be addressed.

Using the bearer token, the client under test will then demonstrate its ability to find
a patient using `$member-match` and retrieve corresponding clinical data using read and search
requests, the `$everything` operation, or the `$export` operation.

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

The tests will complete and the results made available for review.

Note that the requests within the Postman collection do not represent a conheret workflow that a
realistic client would follow. Instead, they represent requests Inferno is required to respond to
successfully based on the requirements in the [PDex Server CapabilityStatement](https://hl7.org/fhir/us/davinci-pdex/STU2/CapabilityStatement-pdex-server.json.html).

## Testing Limitations

The PDex IG is under active development and the IG authors intend to change the approach to the
workflows included within future versions of the IG. In particular the payer to payer workflow
will move from a single-patient workflow to a multi-patient workflow. This test suite focuses on
validating the high-level payer to payer workflow and the ability of clients to use the current
specification to access member data, without doing detailed validation of the mechanisms, 
including authentication, trust establishment, and authorization, because those details are
likely to change in future versions of the PDex specification.

### Happy Path Only

At this time, coverage of additional scenarios beyond the happy path payer to payer workflow
are not validated. These scenarios, such as a failed member match, will be tested in future
versions of the tests.

### Demographic Matching

To reduce burden on tester and avoid the need to implement a robust matching algorithm,
Inferno does not require specific demographics to be provided in the `$member-match`
request. Instead, it will return a hardcoded match regardless of what demographics are provided.

### Data Set

The set of data available on the matched patient is incomplete in the following ways:
- Does not contain instances of the following [member health 
history](https://hl7.org/fhir/us/davinci-pdex/STU2/introduction.html#member-health-history)
profiles:
  - US Core DiagnosticReport Profile for Report and Note exchange
  - US Core Implantable Device Profile
  - US Core Pediatric BMI for Age Observation Profile
  - US Core Pediatric Weight for Height Observation Profile
  - US Core Practitioner Profile
  - US Core PractitionerRole Profile
  - US Core Procedure Profile
  - US Core Provenance Profile
  - US Core Pulse Oximetry Profile
  - US Core Smoking Status Observation Profile
- Does not contain examples of all must support elements populated on the demonstrated profiles.
- May not represent a coherent and clinically valid scenario.

### Authorization

The [PDex Payer to Payer 
workflow](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#member-match-with-consent)
includes two auth steps, one for obtaining a token that allows `$member-match` invocations and another
that gets access for a specific member Patient. Inferno requires that clients choose and send a single
bearer token for the duration of the tests.
