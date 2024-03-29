# == Schema Information
#
# Table name: mailbox_messages
#
#  id                :integer          not null, primary key
#  body              :text             not null
#  content_type      :string           not null
#  uid               :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  mailbox_sender_id :integer          not null
#  message_id        :string
#
# Indexes
#
#  index_mailbox_messages_on_mailbox_sender_id  (mailbox_sender_id)
#
# Foreign Keys
#
#  mailbox_sender_id  (mailbox_sender_id => mailbox_senders.id)
#
class MailboxMessage < ApplicationRecord
  PLAIN_CONTENT_TYPE = "text/plain".freeze
  public_constant :PLAIN_CONTENT_TYPE

  HTML_CONTENT_TYPE = "text/html".freeze
  public_constant :HTML_CONTENT_TYPE

  belongs_to :mailbox_sender

  has_one :mailbox, through: :mailbox_sender

  validates :body, presence: true
  validates :content_type, presence: true, inclusion: { in: %w[text/plain text/html] }

  def plain?
    content_type == PLAIN_CONTENT_TYPE
  end

  def html?
    content_type == HTML_CONTENT_TYPE
  end
end
