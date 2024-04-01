module CurrencyHelper
  def money_currencies_collection
    Money::Currency.all.map do |currency|
      [currency.name, currency.iso_code]
    end
  end

  def currencies_collection(currencies)
    currencies.map do |currency|
      [currency.details[:name], currency.id]
    end
  end

  def print_currency_details(currency)
    details = currency.details
    name = details[:name]
    specs = %i[symbol subunit_to_unit decimal_mark thousands_separator].map do |key|
      "#{key.to_s.humanize}: '#{details[key]}'"
    end.join(" | ")

    "#{name} — #{specs}"
  end
end
