# == Schema Information
#
# Table name: message_condition_groups
#
#  id                    :integer          not null, primary key
#  logical_operator      :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  message_dispatcher_id :integer          not null
#
# Indexes
#
#  index_message_condition_groups_on_message_dispatcher_id  (message_dispatcher_id)
#
# Foreign Keys
#
#  message_dispatcher_id  (message_dispatcher_id => message_dispatchers.id)
#
class MessageConditionGroup < ApplicationRecord
  AND = "AND".freeze
  OR = "OR".freeze

  def self.logical_operators
    [AND, OR]
  end
  public_class_method :logical_operators

  belongs_to :message_dispatcher
  has_many :message_conditions, dependent: :destroy

  validates :logical_operator, presence: true, inclusion: { in: logical_operators }

  def satisfied_by?(message)
    case logical_operator
    when AND
      and_operator_satisfied_by?(message)
    when OR
      or_operator_satisfied_by?(message)
    end
  end

  private

  def and_operator_satisfied_by?(message)
    message_conditions.all? do |message_condition|
      message_condition.satisfied_by?(message)
    end
  end

  def or_operator_satisfied_by?(message)
    message_conditions.any? do |message_condition|
      message_condition.satisfied_by?(message)
    end
  end
end
