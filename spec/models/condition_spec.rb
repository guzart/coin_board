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

RSpec.describe Condition, type: :model do
  it "validates the comparison operator" do
    condition = Condition.new(comparison_operator: "INVALID")
    expect(condition).not_to be_valid
    expect(condition.errors[:comparison_operator]).to include("is not included in the list")
  end

  it "validates the comparison value" do
    condition = Condition.new(comparison_operator: "MATCHES_REGEX")
    expect(condition).not_to be_valid
    expect(condition.errors[:comparison_value]).to include("can't be blank")
  end

  it "validates the lower bound" do
    condition = Condition.new(comparison_operator: "between")
    expect(condition).not_to be_valid
    expect(condition.errors[:lower_bound]).to include("can't be blank")
  end

  it "validates the upper bound" do
    condition = Condition.new(comparison_operator: "between")
    expect(condition).not_to be_valid
    expect(condition.errors[:upper_bound]).to include("can't be blank")
  end

  describe "#satisfied_by?" do
    it "raises an error if the object does not include ConditionComparable" do
      condition = build(:condition)
      object = double("Object")

      expect { condition.satisfied_by?(object) }.to raise_error(ArgumentError)
    end

    it "evaluates the comparison" do
      object = double("Object")
      condition = build(:condition, :exactly_matches_subject, subject: "Welcome!")

      expect(object).to receive(:condition_attribute).with("subject").and_return("Welcome!")

      expect(condition.satisfied_by?(object)).to be(true)
    end
  end

  describe "#between_comparison" do
    it "returns true if the operand is between the lower and upper bounds" do
      condition = build(:condition, comparison_operator: "between", lower_bound: "10", upper_bound: "20")

      expect(condition.send(:between_comparison, 15)).to be(true)
    end

    it "returns false if the operand is not between the lower and upper bounds" do
      condition = build(:condition, comparison_operator: "between", lower_bound: "10", upper_bound: "20")

      expect(condition.send(:between_comparison, 5)).to be(false)
    end
  end
end
