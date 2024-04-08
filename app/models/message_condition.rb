# == Schema Information
#
# Table name: message_conditions
#
#  id                         :integer          not null, primary key
#  comparison_attribute       :string
#  comparison_operator        :string
#  comparison_value           :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  message_condition_group_id :integer          not null
#  sender_id                  :integer
#
# Indexes
#
#  index_message_conditions_on_message_condition_group_id  (message_condition_group_id)
#  index_message_conditions_on_sender_id                   (sender_id)
#
# Foreign Keys
#
#  message_condition_group_id  (message_condition_group_id => message_condition_groups.id)
#  sender_id                   (sender_id => senders.id)
#

# Other operators:
# DOES_NOT_MATCH_REGEX DOES_NOT_BEGIN_WITH DOES_NOT_END_WITH DOES_NOT_CONTAIN DOES_NOT_EXACTLY_MATCH
class MessageCondition < ApplicationRecord
  include ComparisonOperators

  belongs_to :message_condition_group
  belongs_to :sender, optional: true

  has_one :message_dispatcher, through: :message_condition_group

  comparison_operator :begins_with, ->(operand) { operand.start_with?(comparison_value) }
  comparison_operator :contains, ->(operand) { operand.include?(comparison_value) }
  comparison_operator :ends_with, ->(operand) { operand.end_with?(comparison_value) }
  comparison_operator :exactly_matches, ->(operand) { operand == comparison_value }
  comparison_operator :matches_regex, ->(operand) { operand.match?(comparison_value) }

  validates :comparison_attribute, presence: true
  validates :comparison_operator, presence: true, inclusion: { in: comparison_operators.map(&:to_s) }
  validates :comparison_value, presence: true, unless: :sender_comparison?
  validates :sender, presence: true, if: :sender_comparison?

  def satisfied_by?(message)
    operand = message.condition_attribute(comparison_attribute.to_sym)
    evaluate_comparison(comparison_operator, operand)
  end

  def sender_comparison?
    comparison_attribute == "sender"
  end

  def to_s
    "message #{comparison_attribute} #{comparison_operator} \"#{comparison_value_or_sender}\""
  end

  def comparison_value_or_sender
    sender_comparison? ? sender : comparison_value
  end
end
