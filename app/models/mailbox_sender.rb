# == Schema Information
#
# Table name: mailbox_senders
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  name       :string           not null
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  mailbox_id :integer          not null
#
# Indexes
#
#  index_mailbox_senders_on_mailbox_id            (mailbox_id)
#  index_mailbox_senders_on_mailbox_id_and_email  (mailbox_id,email) UNIQUE
#
# Foreign Keys
#
#  mailbox_id  (mailbox_id => mailboxes.id)
#
class MailboxSender < ApplicationRecord
  belongs_to :mailbox
  has_many :mailbox_messages, dependent: :destroy

  enum status: %i[pending blocked approved]

  before_validation :ensure_name_has_value

  normalizes :email, with: ->(email) { Utils::EmailNormalizer.normalize(email) }

  validates :email, presence: true
  validates :name, presence: true

  def approve!
    return if approved?

    update!(status: :approved)
    enqueue_parse_message_jobs
  end

  def block!
    return if blocked?

    update!(status: :blocked)
    mailbox_messages.destroy_all
  end

  private

  def enqueue_parse_message_jobs
    parse_messages_jobs = mailbox_messages.map { |mm| ParseMessageJob.new(mm) }
    ActiveJob.perform_all_later(parse_messages_jobs)
  end

  def ensure_name_has_value
    self.name = email.split("@").first if name.blank?
  end
end
