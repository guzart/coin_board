module CurrencyHelper
  def currencies_collections
    Money::Currency.all.map do |currency|
      [currency.name, currency.iso_code]
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
