# == Schema Information
#
# Table name: providers
#
#  id         :integer          not null, primary key
#  name       :string
#  settings   :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_providers_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Provider < ApplicationRecord
  include ProviderOauth

  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }

  def provider_class
    @provider_class ||= Providers.const_get(name.capitalize) if name.present?
  end

  def provider_instance
    @provider_instance ||= provider_class.new(settings || {}) if provider_class
  end

  def respond_to_missing?(method_name, include_private = false)
    provider_instance.respond_to?(method_name, include_private) || super
  end

  def method_missing(method_name, *args, &block)
    provider_instance.send(method_name, *args, &block)
  end

  def self.available_names
    Providers.constants.map { |provider| Providers.const_get(provider).name }
  end

  private

  def update_provider_settings!
    update!(settings: provider_instance.settings)
  end
end
