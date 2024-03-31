# == Schema Information
#
# Table name: mailbox_message_dispatchers
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
#  index_mailbox_message_dispatchers_on_match_condition_group_id  (match_condition_group_id)
#  index_mailbox_message_dispatchers_on_user_id                   (user_id)
#
# Foreign Keys
#
#  match_condition_group_id  (match_condition_group_id => condition_groups.id)
#  user_id                   (user_id => users.id)
#
class MailboxMessageDispatcher < ApplicationRecord
  belongs_to :user
  belongs_to :match_condition_group, class_name: "ConditionGroup"

  before_validation :ensure_match_condition_group

  validates :name, presence: true

  def to_s
    name
  end

  def matches_mailbox_message?(mailbox_message)
    match_condition_group.satisfied_by?(mailbox_message)
  end

  private

  def ensure_match_condition_group
    return unless new_record? && match_condition_group_id.nil?

    build_match_condition_group(logical_operator: "AND", user:)
  end
end
