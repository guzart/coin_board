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
FactoryBot.define do
  factory :message_condition_group do
    message_dispatcher
    logical_operator { MessageConditionGroup.logical_operators.sample }
  end
end
