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
  OPERATORS = %w[
    MATCHES_REGEX
    BEGINS_WITH
    ENDS_WITH
    CONTAINS
    EXACTLY_MATCHES
    BETWEEN
  ].freeze

  belongs_to :condition_group

  validates :comparison_operator, presence: true, inclusion: { in: OPERATORS }
  validates :comparison_value, presence: true, if: -> { !between? }
  validates :lower_bound, presence: true, if: -> { between? }
  validates :upper_bound, presence: true, if: -> { between? }

  def between?
    comparison_operator == "BETWEEN"
  end
end
