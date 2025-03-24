require_relative '../../../must_support_test'

module DaVinciPDexTestKit
  module PDexPayerServer
    class ExplanationOfBenefitMustSupportTest < Inferno::Test
      include USCoreTestKit::MustSupportTest

      title 'All must support elements are provided in the ExplanationOfBenefit resources returned'
      description %(
        PDex Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the PDex Server Capability
        Statement. This test will look through the ExplanationOfBenefit resources
        found previously for the following must support elements:

        * ExplanationOfBenefit.adjudication
        * ExplanationOfBenefit.adjudication.category
        * ExplanationOfBenefit.adjudication.extension:reviewAction
        * ExplanationOfBenefit.adjudication:adjudicationamounttype
        * ExplanationOfBenefit.adjudication:denialreason
        * ExplanationOfBenefit.careTeam.provider
        * ExplanationOfBenefit.enterer
        * ExplanationOfBenefit.extension:levelOfServiceType
        * ExplanationOfBenefit.facility
        * ExplanationOfBenefit.insurer
        * ExplanationOfBenefit.item.adjudication.extension:reviewAction
        * ExplanationOfBenefit.item.adjudication:adjudicationamounttype
        * ExplanationOfBenefit.item.adjudication:adjudicationamounttype.amount
        * ExplanationOfBenefit.item.adjudication:allowedunits
        * ExplanationOfBenefit.item.adjudication:allowedunits.value
        * ExplanationOfBenefit.item.adjudication:consumedunits
        * ExplanationOfBenefit.item.adjudication:consumedunits.value
        * ExplanationOfBenefit.item.adjudication:denialreason
        * ExplanationOfBenefit.item.adjudication:denialreason.reason
        * ExplanationOfBenefit.item.category
        * ExplanationOfBenefit.item.extension:administrationReferenceNumber
        * ExplanationOfBenefit.item.extension:authorizedItemDetail
        * ExplanationOfBenefit.item.extension:authorizedProvider
        * ExplanationOfBenefit.item.extension:itemTraceNumber
        * ExplanationOfBenefit.item.extension:preAuthIssueDate
        * ExplanationOfBenefit.item.extension:preAuthPeriod
        * ExplanationOfBenefit.item.extension:previousAuthorizationNumber
        * ExplanationOfBenefit.patient
        * ExplanationOfBenefit.preAuthRefPeriod
        * ExplanationOfBenefit.provider
        * ExplanationOfBenefit.status
        * ExplanationOfBenefit.total.category
        * ExplanationOfBenefit.total.extension:priorauth-utilization
        * ExplanationOfBenefit.type
        * ExplanationOfBenefit.use
      )

      id :pdex_eob_must_support_test

      def resource_type
        'ExplanationOfBenefit'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:explanation_of_benefit_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
