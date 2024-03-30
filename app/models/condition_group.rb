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
  OPERATORS = %w[AND OR].freeze

  belongs_to :user
  has_many :conditions, dependent: :destroy

  belongs_to :parent_condition_group, class_name: "ConditionGroup", optional: true

  validates :logical_operator, presence: true, inclusion: { in: OPERATORS }

  accepts_nested_attributes_for :conditions, allow_destroy: true
end
