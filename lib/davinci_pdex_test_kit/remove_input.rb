module DaVinciPDexTestKit
  module RemoveInput
    module_function
    def recursive_remove_input(runnable, input)
      runnable.inputs.delete(input)
      runnable.input_order.delete(input)
      runnable.children.each { |child_runnable| recursive_remove_input(child_runnable, input) }
    end
  end
end