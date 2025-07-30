module DaVinciPDexTestKit
  module PDexPayerClient
    class PDexMemberAuthenticationTest < Inferno::Test
      title 'Uses recognized Health Plan credentials'

      description <<~DESCRIPTION
        The Health IT Module requires members to authenticate
        using credentials issued or recognized by the Health Plan, such as credentials used to access
        a member portal, and accepts only those credentials when processing member-authorized requests.
      DESCRIPTION

      id :pdex_member_authentication_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex_2.0.0@10'

    input :pdex_member_authentication_test_options,
          title: 'Uses recognized Health Plan credentials',
          description: %(
            I attest that the Health IT Module requires members to authenticate
                using credentials issued or recognized by the Health Plan, such as credentials used to access
                a member portal, and accepts only those credentials when processing member-authorized requests.
          ),
          type: 'radio',
          default: 'false',
          options: {
            list_options: [
              {
                label: 'Yes',
                value: 'true'
              },
              {
                label: 'No',
                value: 'false'
              }
            ]
          }
    input :pdex_member_authentication_test_note,
          title: 'Notes, if applicable:',
          type: 'textarea',
          optional: true

    run do
      assert pdex_member_authentication_test_options == 'true', %(
        The following was not satisfied:

            The Health IT Module requires members to authenticate
            using credentials issued or recognized by the Health Plan, such as credentials used to access
            a member portal, and accepts only those credentials when processing member-authorized requests.

      )
      pass pdex_member_authentication_test_note if pdex_member_authentication_test_note.present?
    end

    end
  end
end