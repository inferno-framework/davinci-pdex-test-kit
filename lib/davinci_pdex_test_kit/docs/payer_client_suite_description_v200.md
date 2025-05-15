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

This patient contains examples instances for all resource types in the PDex [member health
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

Inferno's simulated payer endpoints require authentication using the OAuth flows
conforming either to the
- SMART [App Launch flow](https://hl7.org/fhir/smart-app-launch/STU2.2/app-launch.html), or
- UDAP [Consumer-Facing flow](https://hl7.org/fhir/us/udap-security/STU1/consumer.html).

When creating a test session, select the Client Security Type corresponding to an
authentication approach supported by the client. Then, start by running the "Client Registration"
group which will guide you through the registration process, including what inputs to provide. See the
*Auth Configuration Details* section below for details. If the client is not able to use the SMART or
UDAP protocols to obtain an access token, see the *Demonstration* section below for how to use the SMART
or UDAP server tests to obtain an access token that the client can use.

Once registration is complete, run the "Verify PDex Data Access" group and Inferno will 
wait for the client to make PDex resource and search requests from the client, return the requested PDex
resources to the client, and verify the interactions. The demographics of the target
patient are listed in the *Test Methodology* section above.

### Postman-based Demo

If you do not have a PDex client but would like to try the tests out, you can use
the Inferno SMART App Launch test kit to request an access token and
[this postman collection](https://github.com/inferno-framework/davinci-pdex-test-kit/blob/main/PDEX.postman_collection.json)
to make requests against Inferno. To execute the Postman-based demo:

1. Create a PDex Payer Client session, selecting one of the SMART options for the "Client Security Type"
1. In the PDex Payer Client session, select the "Demo: Submit PDex Payer Client Requests With Postman" preset
   from the dropdown in the upper left.
1. Click the `RUN ALL TESTS` button in the upper right and then click the `SUBMIT` button in the input dialog
   that appears. 
1. Register and obtain and access token:
   1. In a separate tab, create a SMART App Launch STU2.2 test session.
   1. Select the "Demo: Run Against the SMART Client Suite" preset corresponding
      to the authentication approach (public, confidential symmetric, or confidential asymmetric) chosen for
      the PDex Payer Client session from the dropdown in the upper left.
   1. Select the "Standalone Launch" group from the list at the left and click the "RUN TESTS" button in the upper right.
   1. In the input dialog the follows, replace the **FHIR Endpoint** input with the FHIR endpoint displayed
      in the wait dialog on the PDex Payer Client session.
   1. Click "SUBMIT" and when the "User Action Required" dialog appears, click the link to authorize and complete the tests.
   1. Find the `standalone_access_token` output in test **1.2.06** "Token exchange response body contains required information
      encoded in JSON", and copy the value, which will be a ~100 character string of letters and numbers (e.g.,
      eyJjbGllbnRfaWQiOiJzbWFydF9jbGllbnRfdGVzdF9kZW1vIiwiZXhwaXJhdGlvbiI6MTc0MzUxNDk4Mywibm9uY2UiOiJlZDI5MWIwNmZhMTE4OTc4In0).
1. In the "User Action Required" dialog in the PDex Payer Client session, click to confirm client configuration. Another
   "User Action Required" dialog will appear asking for the client to make PDex requests.
1. Download the [collection](https://github.com/inferno-framework/davinci-pdex-test-kit/blob/main/PDEX.postman_collection.json) 
   and import it into [Postman](https://www.postman.com/downloads/) if not already done.
1. Open the "Variables" tab of the `PDEX` collection, paste the access value obtained in the previous step into the "Current value"
   column for the "access_token" variable, and save the collection.
1. Use Postman to send a `$member-match` request found in the "$member-match Requests" folder
   (the `missing CoverageToMatch` entry will return a result, but will fail request validation). 
1. Next, use the "Patient GET by identifier" request in the "Patient id Search" folder to turn the
   returned Patient identifier (`99999` in system 
   `http://github.com/inferno-framework/target-payer/identifiers/member`) into a Patient resource id (`999`).  
1. Now, make clinical data requests found in the other
   folders representing the three data access approaches: "Read and Search Requests", 
   "Patient $everything Requests", or "$export Requests". Specific paths that will completely pass
   the tests include:
   - Make each request within the "Read and Search Requests" folder to individually request instances
     for each resource type associated with the returned patient.
   - Make the "$everything" request in the "Patient $everything Requests". Then use the response to
     get the next page by copying the url in the `Bundle.link` entry with `relation` "next" and put
     it as the URL for the "$everything next page" request. Make that request to get the next page
     of the response Bundle and then repeat with that response until there are no more "next" links.
     You should need to make 2 next page requests total.
   - Perform an `$export` by first making the "export kick-off" request. Then, copy the value of
     the `content-location` response header into the URL of the "export status" request. Make that
     request until it returns a body with JSON content (will be a few minutes). Next for each
     `output` entry, copy the `url` into the URL of the "ndjson retrieval" request and make it to
     get the data. Finally, make the "Read and Search Requests" to Read the Location
     and PractitionerRole instances since those aren't returned by the `$export` operation.
1. After making all the requests you want, click the "Click here" link in the PDex Payer Client tests
   to finish execution. Review the results.

#### Optional Demo Modification: Tester-provided Client Id

NOTE: Inferno uses **Client Id** input and the generated bearer tokens sent in the `Authorization` HTTP header 
to associate requests with sessions. If multiple concurrent sessions are configured
to use the same token, they may interfere with each other. To prevent concurrent executors
of these sample executions from disrupting your session it is recommended, but not required, to:
1. When running the Client Registration test group, leave the **Client Id** input blank or provide your own unique or
   random value.
2. When the wait dialog appears for confirmation of client registration, note the indicated `Client Id` value and copy it
   into the **Client ID** input of the SMART tests.

#### Optional Demo Modification: UDAP Authentication

To run the demonstration using UDAP authentication to obtain an access token, replace step 4. "Register and obtain and access token"
with the following:

1. In another tab, start an Inferno session for the UDAP Security Server test suite. Select the "Demo: Run Against the UDAP Security
   Client Suite" preset
1. Select the "UDAP Authorization Code Flow" group, click the "RUN TESTS" button, and update the **FHIR Server Base URL**
   input with the FHIR server URL displayed in the wait dialog of the PDex Payer Client test session.
1. Click the "SUBMIT" button and click to authorize in the "User Action Required" dialog that appears, which will complete
   the tests.
1. Find the `udap_auth_code_flow_access_token` output in test **1.3.04** "Token exchange response body contains required information
   encoded in JSON", and copy the value, which will be a ~100 character string of letters and numbers (e.g.,
   eyJjbGllbnRfaWQiOiJzbWFydF9jbGllbnRfdGVzdF9kZW1vIiwiZXhwaXJhdGlvbiI6MTc0MzUxNDk4Mywibm9uY2UiOiJlZDI5MWIwNmZhMTE4OTc4In0).
1. Return to the PDex Payer Client test session and confirm that UDAP registration has been completed in the current
   "User Action Required" dialog.

The PDex Client Registration tests will pass with the possible exception of some UDAP registration details.

## Input Details

### Auth Configuration Details

When running these tests there are 4 options for authentication, which also allows 
Inferno to identify which session the requests are for. The choice is made when the
session is created with the selected Client Security Type option, which determines
what details the tester needs to provide during the Client Registration tests:

- **SMART App Launch Client**: the system under test will manually register
  with Inferno and request access tokens to use when accessing FHIR endpoints
  as per the SMART App Luanch specification, which includes providing one or more
  redirect URI(s) in the **SMART App Launch Redirect URI(s)** input, and optionally,
  launch URL(s) in the **SMART App Launch URL(s)** input. Additionally, testers may provide
  a **Client Id** if they want their client assigned a specific one. Depending on the
  specific SMART flavor chosen, additional inputs for authentication may be needed:
  - **SMART App Launch Public Client**: no additional authentication inputs
  - **SMART App Launch Confidential Symmetric Client**: provide a secret using the
    **SMART Confidential Symmetric Client Secret** input.
  - **SMART App Launch Confidential Asymmetric Client**: provide a URL that resolves
    to a JWKS or a raw JWKS in JSON format using the **SMART JSON Web Key Set (JWKS)** input.
- **UDAP Authorization Code Client**: the system under test will dynamically register
  with Inferno and request access tokens used to access FHIR endpoints
  as per the UDAP specification. It requires the **UDAP Client URI** input
  to be populated with the URI that the client will use when dynamically
  registering with Inferno. This will be used to generate a client id (each
  unique UDAP Client URI will always get the same client id). All other details
  that Inferno needs will be provided as a part of the dynamic registration.

### Inputs Controlling Token Responses

Inferno's SMART simulation does not include the details needed to populate
the token response [context data](https://hl7.org/fhir/smart-app-launch/STU2.2/scopes-and-launch-context.html)
when requested by apps using scopes during the *SMART App Launch* flow. If the tested app
needs and will request these details, the tester must provide them for Inferno
to respond with using the following inputs:
- **Launch Context**: Testers can provide a JSON
  array for Inferno to use as the base for building a token response on. This can include
  keys like `"patient"` when the `launch/patient` scope will be requested. Note that when keys that Inferno
  also populates (e.g. `access_token` or `id_token`) are included, the Inferno value will be returned.
- **FHIR User Relative Reference**: Testers
  can provide a FHIR relative reference (`<resource type>/<id>`) for the FHIR user record
  to return with the `id_token` when the `openid` and `fhirUser` scopes are requested.
  If populated, ensure that the referenced resource is available in Inferno's simulated
  FHIR server so that it can be accessed.

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
versions of these tests.

### Demographic Matching

To reduce burden on tester and avoid the need to implement a robust matching algorithm,
Inferno does not require specific demographics to be provided in the `$member-match`
request. Instead, it will return a hardcoded match regardless of what demographics are provided.

### Data Set

The set of data available on the matched patient is incomplete in the following ways:
- While it contains instances of all resource types in the [member health 
history](https://hl7.org/fhir/us/davinci-pdex/STU2/introduction.html#member-health-history),
it does not contain instances of the following profiles:
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
- Not all instances have corresponding Provenance resources.
- May not represent a coherent and clinically valid scenario.

### Authorization

The [PDex Payer to Payer 
workflow](https://hl7.org/fhir/us/davinci-pdex/STU2/payertopayerexchange.html#member-match-with-consent)
includes two auth steps, one for obtaining a token that allows `$member-match` invocations and another
that gets access for a specific member Patient. Inferno requires that clients choose and send a single
bearer token for the duration of the tests.

### Required Patient id Search 

The [HRex 1.0.0 $member-match
operation](https://hl7.org/fhir/us/davinci-hrex/STU1/OperationDefinition-member-match.html#membermatch)
returns a patient `identifier`, but not the id of the Patient instance. While the [current version of HRex 
`$member-match`](https://build.fhir.org/ig/HL7/davinci-ehrx/OperationDefinition-member-match.html#parameters)
does support returning, HRex 1.0.0 was the version published when PDex 2.0.0 was published so this test suite's
simulation of `$member-match` does not return the Patient resource id. Thus, client systems need to perform a
Patient-level search interaction using that identifier to get resource id which can then be used to request
additional clinical data. This isn't explicitly required by PDex but it is supported and is needed to
accomplish the workflow goals with the available operations.