module MessageConditionHelper
  def comparison_operators_collection
    MessageCondition.comparison_operators.map { |operator| [operator.to_s.humanize(capitalize: false), operator] }
  end
end
