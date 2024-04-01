# == Schema Information
#
# Table name: message_dispatchers
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  currency_id :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_message_dispatchers_on_currency_id  (currency_id)
#  index_message_dispatchers_on_user_id      (user_id)
#
# Foreign Keys
#
#  currency_id  (currency_id => currencies.id)
#  user_id      (user_id => users.id)
#
class MessageDispatcher < ApplicationRecord
  belongs_to :user
  belongs_to :currency

  has_one :message_condition_group, dependent: :destroy

  before_validation :ensure_message_condition_group

  validates :name, presence: true

  def to_s
    name
  end

  def matches_message?(message)
    message_condition_group.satisfied_by?(message)
  end

  def parse_transaction(message)
    raise NotImplementedError
  end

  def dispatch_transaction(transaction_attrs)
    raise NotImplementedError
  end

  private

  def ensure_message_condition_group
    return unless new_record? && message_condition_group.nil?

    build_message_condition_group(logical_operator: "AND")
  end
end
