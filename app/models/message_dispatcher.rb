# == Schema Information
#
# Table name: message_dispatchers
#
#  id                         :integer          not null, primary key
#  name                       :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  message_condition_group_id :integer          not null
#  user_id                    :integer          not null
#
# Indexes
#
#  index_message_dispatchers_on_message_condition_group_id  (message_condition_group_id)
#  index_message_dispatchers_on_user_id                     (user_id)
#
# Foreign Keys
#
#  message_condition_group_id  (message_condition_group_id => message_condition_groups.id)
#  user_id                     (user_id => users.id)
#
class MessageDispatcher < ApplicationRecord
  belongs_to :user
  belongs_to :message_condition_group

  before_validation :ensure_message_condition_group

  validates :name, presence: true

  def to_s
    name
  end

  def matches_mailbox_message?(mailbox_message)
    message_condition_group.satisfied_by?(mailbox_message)
  end

  private

  def ensure_message_condition_group
    return unless new_record? && message_condition_group_id.nil?

    build_message_condition_group(logical_operator: "AND", user:)
  end
end
