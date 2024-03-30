# == Schema Information
#
# Table name: mailbox_message_parsers
#
#  id                       :integer          not null, primary key
#  name                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  match_condition_group_id :integer          not null
#  user_id                  :integer          not null
#
# Indexes
#
#  index_mailbox_message_parsers_on_match_condition_group_id  (match_condition_group_id)
#  index_mailbox_message_parsers_on_user_id                   (user_id)
#
# Foreign Keys
#
#  match_condition_group_id  (match_condition_group_id => condition_groups.id)
#  user_id                   (user_id => users.id)
#
class MailboxMessageParser < ApplicationRecord
  belongs_to :user
  belongs_to :match_condition_group, class_name: "ConditionGroup"

  accepts_nested_attributes_for :match_condition_group, update_only: true
end
