# == Schema Information
#
# Table name: conditions
#
#  id                   :integer          not null, primary key
#  comparison_attribute :string
#  comparison_operator  :string           not null
#  comparison_value     :string
#  lower_bound          :string
#  upper_bound          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  condition_group_id   :integer          not null
#
# Indexes
#
#  index_conditions_on_condition_group_id  (condition_group_id)
#
# Foreign Keys
#
#  condition_group_id  (condition_group_id => condition_groups.id)
#

# Other operators:
# IS_ONE_OF DOES_NOT_MATCH_REGEX DOES_NOT_BEGIN_WITH DOES_NOT_END_WITH DOES_NOT_CONTAIN
# DOES_NOT_EXACTLY_MATCH IS_NOT_ONE_OF `<` `>` `≥` `≤`
class Condition < ApplicationRecord
  include ComparisonOperators

  belongs_to :condition_group

  comparison_operator :begins_with, ->(operand) { operand.start_with?(comparison_value) }
  comparison_operator :between, :between_comparison
  comparison_operator :contains, ->(operand) { operand.include?(comparison_value) }
  comparison_operator :ends_with, ->(operand) { operand.end_with?(comparison_value) }
  comparison_operator :exactly_matches, ->(operand) { operand == comparison_value }
  comparison_operator :matches_regex, ->(operand) { operand.match?(comparison_value) }

  validates :comparison_attribute, presence: true
  validates :comparison_operator, presence: true, inclusion: { in: comparison_operators }
  validates :comparison_value, presence: true, if: -> { !between_condition? }
  validates :lower_bound, presence: true, if: -> { between_condition? }
  validates :upper_bound, presence: true, if: -> { between_condition? }

  def satisfied_by?(object)
    raise ArgumentError, "Object must include ConditionComparable" unless object.respond_to?(:condition_attribute)

    operand = object.condition_attribute(comparison_attribute)
    evaluate_comparison(comparison_operator, operand)
  end

  private

  def between_comparison(operand)
    # only supports numeric values (for now)
    operand > BigDecimal(lower_bound) && operand < BigDecimal(upper_bound)
  end
end
