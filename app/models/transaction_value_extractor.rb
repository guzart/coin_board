# == Schema Information
#
# Table name: transaction_value_extractors
#
#  id                    :integer          not null, primary key
#  extraction_type       :integer
#  extraction_value      :string
#  field                 :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  message_dispatcher_id :integer          not null
#
# Indexes
#
#  index_transaction_value_extractors_on_message_dispatcher_id  (message_dispatcher_id)
#
# Foreign Keys
#
#  message_dispatcher_id  (message_dispatcher_id => message_dispatchers.id)
#
class TransactionValueExtractor < ApplicationRecord
  belongs_to :message_dispatcher

  enum field: %i[amount payee_name]
  enum extraction_type: %i[regex_group]

  normalizes :extraction_value, with: ->(value) { Utils::UserRegexNormalizer.normalize(value) }

  validates :extraction_type, presence: true
  validates :extraction_value, presence: true
  validates :field, presence: true, uniqueness: { scope: :message_dispatcher_id }

  def extract(content, currency:)
    regex = Regexp.new extraction_value
    value = regex.match(content).captures.first
    return value unless amount?

    value = value.gsub(currency.decimal_mark, ".").gsub(currency.thousands_separator, "")
    BigDecimal(value)
  end

  def to_s
    "TransactionValueExtractor #{field}=#{extraction_type}(#{extraction_value})"
  end
end
