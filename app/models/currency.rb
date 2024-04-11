# == Schema Information
#
# Table name: currencies
#
#  id                  :integer          not null, primary key
#  decimal_mark        :string
#  iso_code            :string
#  name                :string
#  subunit_to_unit     :integer
#  symbol              :string
#  thousands_separator :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer          not null
#
# Indexes
#
#  index_currencies_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Currency < ApplicationRecord
  CUSTOM_ISO_CODE = "custom".freeze
  public_constant :CUSTOM_ISO_CODE

  belongs_to :user

  validates :iso_code, presence: true
  with_options if: :custom? do |custom|
    custom.validates :name, presence: true
    custom.validates :symbol, presence: true
    custom.validates :subunit_to_unit, presence: true
    custom.validates :decimal_mark, length: { is: 1 }
    custom.validates :thousands_separator, length: { is: 1 }
  end

  def iso?
    !custom?
  end

  def custom?
    iso_code == CUSTOM_ISO_CODE
  end

  def details
    iso? ? details_from_money_currency : details_from_custom_currency
  end

  def to_s
    custom? ? name : (Money::Currency.find(iso_code)&.name || iso_code)
  end

  def parse_amount(amount)
    details_cache = details
    value = amount.gsub(details_cache[:thousands_separator], "")
                  .gsub(details_cache[:decimal_mark], ".")
                  .gsub(/[^0-9.]/, "")
    BigDecimal(value)
  end

  private

  def details_from_money_currency
    currency = Money::Currency.find(iso_code)
    %i[name symbol subunit_to_unit decimal_mark thousands_separator].map do |attr|
      [attr, currency.public_send(attr)]
    end.to_h
  end

  def details_from_custom_currency
    { name:, symbol:, subunit_to_unit:, decimal_mark:, thousands_separator: }
  end
end
