# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  body         :text
#  content_type :string
#  sent_at      :datetime
#  status       :integer          default("pending"), not null
#  subject      :string
#  uid          :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  email_id     :string
#  sender_id    :integer          not null
#
# Indexes
#
#  index_messages_on_sender_id  (sender_id)
#
# Foreign Keys
#
#  sender_id  (sender_id => senders.id)
#
class Message < ApplicationRecord
  include ConditionAttributes

  PLAIN_CONTENT_TYPE = "text/plain".freeze
  public_constant :PLAIN_CONTENT_TYPE

  HTML_CONTENT_TYPE = "text/html".freeze
  public_constant :HTML_CONTENT_TYPE

  belongs_to :sender

  has_one :mailbox, through: :sender
  has_one :user, through: :mailbox

  enum status: %i[pending no_dispatcher dispatched]

  scope :expired, -> { dispatched.where("updated_at < ?", 2.days.ago) }
  scope :waiting_dispatch, -> { where(status: %i[pending no_dispatcher]) }

  attribute_for_condition :body
  attribute_for_condition :subject
  attribute_for_condition :sender, -> { sender_id }

  normalizes :subject, with: ->(subject) { subject.to_s.strip.presence }

  validates :body, presence: true
  validates :content_type, presence: true, inclusion: { in: %w[text/plain text/html] }

  def plain?
    content_type == PLAIN_CONTENT_TYPE
  end

  def html?
    content_type == HTML_CONTENT_TYPE
  end
end
