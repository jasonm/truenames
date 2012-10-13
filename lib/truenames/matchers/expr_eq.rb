require 'rspec/matchers/built_in/eq'

module Truenames
  module Matchers
    def expr_eq(other)
      Truenames::Matchers::ExprEq.new(other)
    end

    class ExprEq < RSpec::Matchers::BuiltIn::Eq
      def name
        "eq"
      end
    end
  end
end
