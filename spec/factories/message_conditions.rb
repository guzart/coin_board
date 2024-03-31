# == Schema Information
#
# Table name: message_conditions
#
#  id                         :integer          not null, primary key
#  comparison_attribute       :string
#  comparison_operator        :string
#  comparison_value           :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  message_condition_group_id :integer          not null
#  sender_id                  :integer
#
# Indexes
#
#  index_message_conditions_on_message_condition_group_id  (message_condition_group_id)
#  index_message_conditions_on_sender_id                   (sender_id)
#
# Foreign Keys
#
#  message_condition_group_id  (message_condition_group_id => message_condition_groups.id)
#  sender_id                   (sender_id => senders.id)
#
FactoryBot.define do
  factory :message_condition do
    message_condition_group
    comparison_attribute { Faker::Lorem.word }
    comparison_operator { MessageCondition.comparison_operators.sample }
    comparison_value { Faker::Lorem.word }

    trait :exactly_matches_subject do
      transient do
        subject { Faker::Lorem.word }
      end

      comparison_attribute { "subject" }
      comparison_operator { "exactly_matches" }
      comparison_value { subject }
    end

    trait :contains_body do
      transient do
        body { Faker::Lorem.paragraph }
      end

      comparison_attribute { "body" }
      comparison_operator { "contains" }
      comparison_value { body }
    end
  end
end
