# == Schema Information
#
# Table name: mailboxes
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_mailboxes_on_email    (email) UNIQUE
#  index_mailboxes_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Mailbox < ApplicationRecord
  belongs_to :user
  has_many :mailbox_senders, dependent: :destroy

  before_validation :generate_email

  normalizes :email, with: ->(email) { Utils::EmailNormalizer.normalize(email) }

  validates :email, uniqueness: true, presence: true

  private

  def generate_email
    return unless email.blank?

    email_template = ENV.fetch("MAILBOX_EMAIL_TEMPLATE")
    self.email = email_template.gsub("{code}", SecureRandom.hex(10))
  end
end
