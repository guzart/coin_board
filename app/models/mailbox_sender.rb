# == Schema Information
#
# Table name: mailbox_senders
#
#  id         :integer          not null, primary key
#  allowed    :boolean          default(FALSE), not null
#  email      :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  mailbox_id :integer          not null
#
# Indexes
#
#  index_mailbox_senders_on_email       (email)
#  index_mailbox_senders_on_mailbox_id  (mailbox_id)
#
# Foreign Keys
#
#  mailbox_id  (mailbox_id => mailboxes.id)
#
class MailboxSender < ApplicationRecord
  belongs_to :mailbox
  before_validation :ensure_name_has_value

  scope :allowed, -> { where(allowed: true) }

  normalizes :email, with: ->(email) { Utils::EmailNormalizer.normalize(email) }

  validates :email, presence: true
  validates :name, presence: true

  private

  def ensure_name_has_value
    self.name = email.split("@").first if name.blank?
  end
end
