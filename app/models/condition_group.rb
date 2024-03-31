# == Schema Information
#
# Table name: condition_groups
#
#  id                        :integer          not null, primary key
#  logical_operator          :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  parent_condition_group_id :integer
#  user_id                   :integer          not null
#
# Indexes
#
#  index_condition_groups_on_parent_condition_group_id  (parent_condition_group_id)
#  index_condition_groups_on_user_id                    (user_id)
#
# Foreign Keys
#
#  parent_condition_group_id  (parent_condition_group_id => condition_groups.id)
#  user_id                    (user_id => users.id)
#
class ConditionGroup < ApplicationRecord
  AND = "AND".freeze
  OR = "OR".freeze

  def self.logical_operators
    [AND, OR]
  end
  public_class_method :logical_operators

  belongs_to :user
  belongs_to :parent_condition_group, class_name: "ConditionGroup", optional: true

  has_many :conditions, dependent: :destroy
  has_many :child_condition_groups, class_name: "ConditionGroup", foreign_key: :parent_condition_group_id

  validates :logical_operator, presence: true, inclusion: { in: logical_operators }

  def satisfied_by?(instance)
    case logical_operator
    when AND
      and_operator_satisfied_by?(instance)
    when OR
      or_operator_satisfied_by?(instance)
    end
  end

  private

  def and_operator_satisfied_by?(instance)
    child_condition_groups.all? { |group| group.satisfied_by?(instance) } &&
      conditions.all? do |condition|
        condition.satisfied_by?(instance)
      end
  end

  def or_operator_satisfied_by?(instance)
    child_condition_groups.any? { |group| group.satisfied_by?(instance) } ||
      conditions.any? do |condition|
        condition.satisfied_by?(instance)
      end
  end
end
