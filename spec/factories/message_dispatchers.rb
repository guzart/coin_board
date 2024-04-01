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
FactoryBot.define do
  factory :message_dispatcher do
    user
    name { Faker::Lorem.word }
  end
end
