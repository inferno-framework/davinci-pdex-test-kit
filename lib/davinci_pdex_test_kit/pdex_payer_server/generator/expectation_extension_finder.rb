
module DaVinciPDexTestKit                                                                                                                                                                                           module PDexPayerServer
    class Generator
      module ExpectationExtensionFinder
        def find_expectation_code(backbone_element)
          backbone_element.extension
                          &.find{ |ext| ext.url == 'http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation' }
                          &.valueCode
        end
      end
    end
  end
end
