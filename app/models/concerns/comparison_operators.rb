module ComparisonOperators
  extend ActiveSupport::Concern

  included do
    cattr_accessor :comparison_operators_map, default: {}

    def evaluate_comparison(operator, operand)
      operator_callback = comparison_operators_map[operator.to_sym]
      return send(operator_callback, operand) if operator_callback.is_a?(Symbol)

      instance_exec(operand, &operator_callback)
    end
  end

  class_methods do
    def comparison_operator(name, operator)
      comparison_operators_map[name.to_sym] = operator

      define_method "#{name}_condition?" do
        comparison_operator == name.to_s
      end
    end

    def comparison_operators
      comparison_operators_map.keys
    end
  end
end
