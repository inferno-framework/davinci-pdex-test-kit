The Da Vinci Payer Data Exchange (PDex) Test Kit validates the conformance of PDex client and server implementations to [version 2.0.0 of the Da Vinci PDex Implementation Guide](https://hl7.org/fhir/us/davinci-pdex/STU2/).
<!-- break -->

## Status

These tests are a DRAFT intended to allow PDex implementers to perform preliminary checks of their implementations against the PDex IG requirements and provide feedback on the tests. Future versions of these tests may validate other requirements and may change how these are tested.

## Test Scope and Limitations

Documentation of the current tests and their limitations can be found in each suite’s description when the tests are run and can also be viewed in the source code:

 - [Here](https://github.com/inferno-framework/davinci-pdex-test-kit/blob/main/lib/davinci_pdex_test_kit/docs/payer_client_suite_description_v200.md) for the Payer Client Test Suite
 - [Here](https://github.com/inferno-framework/davinci-pdex-test-kit/blob/main/lib/davinci_pdex_test_kit/docs/payer_server_suite_description_v200.md) for the Payer Server Test Suite

### Test Scope

To validate the behavior of the system under test, Inferno will act as an exchange partner. Specifically,

 - **When testing a payer client:** Inferno will simulate a PDex payer server for the client under test to interact with. The client will be expected to initiate requests to the server and demonstrate its ability to react to the returned responses. Over the course of these interactions, Inferno will seek to observe the conformant transfer of member data from an old payer (represented by Infero) to a new payer (represented by the client under test).
 - **When testing a server:** Inferno will simulate a PDex payer client for the server under test to interact with. The server will be expected to respond to requests made by Inferno. Over the course of these interactions, Inferno will seek to observe the conformant transfer of member data from an old payer (represented by the server under test) to a new payer (represented by Inferno).

The test suites for both PDex clients and servers follow the same basic outline, each testing:

 - A complete payer to payer single-member data exchange workflow
 - Coverage of additional cases and must support elements (currently not present in the client tests)

### Known Limitations

The PDex IG is under active development and the IG authors intend to change the approach to the workflows included within future versions of the IG. In particular, the payer to payer workflow will move from a single-patient workflow to a multi-patient workflow. This test suite focuses on validating the high-level payer to payer workflow and the ability of clients to use the current specification to access member data, without doing detailed validation of the mechanisms, including authentication and trust establishment, because those details are likely to change in future versions of the PDex specification.

## Reporting Issues

Please report any issues with this set of tests in the [GitHub Issues](https://github.com/inferno-framework/davinci-pdex-test-kit/issues) section of the [open-source code repository](https://github.com/inferno-framework/davinci-pdex-test-kit).
