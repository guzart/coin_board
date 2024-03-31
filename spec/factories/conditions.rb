# == Schema Information
#
# Table name: conditions
#
#  id                   :integer          not null, primary key
#  comparison_attribute :string
#  comparison_operator  :string           not null
#  comparison_value     :string
#  lower_bound          :string
#  upper_bound          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  condition_group_id   :integer          not null
#
# Indexes
#
#  index_conditions_on_condition_group_id  (condition_group_id)
#
# Foreign Keys
#
#  condition_group_id  (condition_group_id => condition_groups.id)
#
FactoryBot.define do
  factory :condition do
    comparison_attribute { Faker::Lorem.word }
    comparison_operator { Condition.comparison_operators.sample }
    comparison_value { Faker::Lorem.word }
    condition_group

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
