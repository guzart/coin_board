module TransactionValueExtractorHelper
  def print_extraction_value(extraction_value)
    Utils::UserRegexNormalizer.denormalize(extraction_value)
  end
end
