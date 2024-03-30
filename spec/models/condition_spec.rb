# == Schema Information
#
# Table name: conditions
#
#  id                  :integer          not null, primary key
#  comparison_operator :string           not null
#  comparison_value    :string
#  lower_bound         :string
#  upper_bound         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  condition_group_id  :integer          not null
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
    condition = Condition.new(comparison_operator: "BETWEEN")
    expect(condition).not_to be_valid
    expect(condition.errors[:lower_bound]).to include("can't be blank")
  end

  it "validates the upper bound" do
    condition = Condition.new(comparison_operator: "BETWEEN")
    expect(condition).not_to be_valid
    expect(condition.errors[:upper_bound]).to include("can't be blank")
  end
end
