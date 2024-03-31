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
FactoryBot.define do
  factory :condition_group do
    logical_operator { ConditionGroup.logical_operators.sample }
    user
  end
end
