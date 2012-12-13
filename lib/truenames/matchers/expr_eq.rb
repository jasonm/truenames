require 'rspec/matchers/built_in/eq'
require 'binding_of_caller'

module Truenames
  module Matchers
    def expr_eq(other)
      Truenames::Matchers::ExprEq.new(other)
    end

    class ExprEq < RSpec::Matchers::BuiltIn::Eq
      def initialize(expected = nil)
        @expected = expected

        # One to escape this binding, one to escape the Truenames::Matchers#expr_eq wrapper method
        @binding = binding.of_caller(2)
      end

      def name
        "eq"
      end

      def failure_message_for_should
        "\nexpected: #{inspect_references_for(expected)}\n" +
          "     got: #{inspect_references_for(actual)}\n\n(compared using ==)\n"
      end

      private

      def inspect_references_for(value)
        references = reference_names_for(value)

        if references.empty?
          value.inspect
        else
          references
        end
      end

      def reference_names_for(value)
        if value.is_a?(Array)
          "[" + value.map { |each_value| [reference_names_for(each_value)].flatten.first }.join(', ') + "]"
        else
          (matching_locals(value) + matching_ivars(value) + matching_lets(value)).join(' or ')
        end
      end

      def matching_locals(value)
        binding_locals.select { |local| useful_match?(@binding.eval(local.to_s), value) }
      end

      def matching_ivars(value)
        binding_ivars.select { |ivar| useful_match?(@binding.eval(ivar.to_s), value) }
      end

      def matching_lets(value)
        binding_lets.
          select { |let_name, let_value| useful_match?(let_value, value) }.
          map { |let_name, let_value| "let(#{let_name.inspect})" }
      end

      def useful_match?(candidate, value)
        # exclude the matcher itself
        return false if candidate.is_a?(RSpec::Matchers::BuiltIn::Eq)

        candidate == value
      end

      def binding_locals
        @binding.eval("local_variables")
      end

      def binding_ivars
        @binding.eval("instance_variables")
      end

      def binding_lets
        # ~/.rvm/gems/ruby-1.9.3-p194/gems/rspec-core-2.11.1/lib/rspec/core/let.rb
        #
        # def let(name, &block)
        #   define_method(name) do
        #     __memoized.fetch(name) {|k| __memoized[k] = instance_eval(&block) }
        #   end
        # end
        @binding.eval("__memoized")
      end
    end
  end
end
