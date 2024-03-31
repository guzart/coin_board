# == Schema Information
#
# Table name: senders
#
#  id         :integer          not null, primary key
#  email      :string
#  name       :string
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  mailbox_id :integer          not null
#
# Indexes
#
#  index_senders_on_mailbox_id            (mailbox_id)
#  index_senders_on_mailbox_id_and_email  (mailbox_id,email) UNIQUE
#
# Foreign Keys
#
#  mailbox_id  (mailbox_id => mailboxes.id)
#
class Sender < ApplicationRecord
  belongs_to :mailbox
  has_many :messages, dependent: :destroy

  enum status: %i[pending blocked approved]

  scope :pending, -> { where(status: :pending) }

  before_validation :ensure_name_has_value

  normalizes :email, with: ->(email) { Utils::EmailNormalizer.normalize(email) }

  validates :email, presence: true
  validates :name, presence: true

  def approve!
    return if approved?

    update!(status: :approved)
    enqueue_dispatch_message_jobs
  end

  def block!
    return if blocked?

    update!(status: :blocked)
    messages.destroy_all
  end

  def to_s
    "#{name} <#{email}>"
  end

  private

  def enqueue_dispatch_message_jobs
    dispatch_messages_jobs = messages.map { |m| DispatchMessageJob.new(m) }
    ActiveJob.perform_all_later(dispatch_messages_jobs)
  end

  def ensure_name_has_value
    self.name = email.split("@").first if name.blank?
  end
end
