module MessageConditionHelper
  def message_comparison_attributes_collection
    Message.condition_attributes.map { |attribute| [attribute.to_s.humanize, attribute] }
  end

  def message_comparison_operators_collection
    MessageCondition.comparison_operators.map { |operator| [operator.to_s.humanize(capitalize: false), operator] }
  end

  def message_comparison_value_senders_collection(senders)
    senders.map { |sender| [sender.to_s, sender.id] }.sort { |a, b| a[0] <=> b[0] }
  end
end
