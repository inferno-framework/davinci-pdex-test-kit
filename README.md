# Da Vinci Provider Data Exchange (PDex) Test Kit

This is an [Inferno](https://github.com/inferno-community/inferno-core) 
test kit for the [Da Vinci Provider Data Exchange (PDex) FHIR
Implementation Guide](https://hl7.org/fhir/us/davinci-pdex/).

## Documentation
- [Inferno documentation](https://inferno-framework.github.io/inferno-core/)
- [Ruby API documentation](https://inferno-framework.github.io/inferno-core/docs)
- [JSON API documentation](https://inferno-framework.github.io/inferno-core/api-docs)

## PDEX Client Tests
- **Extremely draft state**
- Can generate basic tests with the init-gen.rb file
- Requests are currently hardcoded forwarded to a local server, assumed to be hosted on docker.  This is found in
  `lib/davinci_pdex_test_kit/mock_server.rb`'s `server_proxy`.
- Postman collection exists for mocking the client, at `PDEX-mock-client.postman_collection.json`
- - Currently facing some socket hangup issues, so if you run the collection you need to set it to continue running 
    even if it encounters an error


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
