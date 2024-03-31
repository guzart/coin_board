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
require "rails_helper"

RSpec.describe MessageCondition, type: :model do
  it "validates the comparison operator" do
    message_condition = build(:message_condition, comparison_operator: "INVALID")
    expect(message_condition).not_to be_valid
    expect(message_condition.errors[:comparison_operator]).to include("is not included in the list")
  end

  it "validates the comparison value" do
    message_condition = build(:message_condition, comparison_value: "")
    expect(message_condition).not_to be_valid
    expect(message_condition.errors[:comparison_value]).to include("can't be blank")
  end

  describe "#satisfied_by?" do
    it "evaluates the comparison" do
      object = double("Object")
      message_condition = build(:message_condition, :exactly_matches_subject, subject: "Welcome!")

      expect(object).to receive(:condition_attribute).with("subject").and_return("Welcome!")

      expect(message_condition.satisfied_by?(object)).to be(true)
    end
  end
end
