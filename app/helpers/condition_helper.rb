module ConditionHelper
  def comparison_operators_collection
    Condition.comparison_operators.map { |operator| [operator.to_s.humanize(capitalize: false), operator] }
  end
end
