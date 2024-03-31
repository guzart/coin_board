# == Schema Information
#
# Table name: condition_groups
#
#  id                        :integer          not null, primary key
#  logical_operator          :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  parent_condition_group_id :integer
#  user_id                   :integer          not null
#
# Indexes
#
#  index_condition_groups_on_parent_condition_group_id  (parent_condition_group_id)
#  index_condition_groups_on_user_id                    (user_id)
#
# Foreign Keys
#
#  parent_condition_group_id  (parent_condition_group_id => condition_groups.id)
#  user_id                    (user_id => users.id)
#
require "rails_helper"

RSpec.describe ConditionGroup, type: :model do
  it "validates the logical operator" do
    condition_group = ConditionGroup.new(logical_operator: "INVALID")
    expect(condition_group).not_to be_valid
    expect(condition_group.errors[:logical_operator]).to include("is not included in the list")
  end

  describe "#satisfied_by?" do
    it "evaluates the logical operator AND" do
      object = double("Object")
      condition_group = build(
        :condition_group,
        logical_operator: "AND",
        conditions: [
          build(:condition, :exactly_matches_subject, subject: "Welcome!"),
          build(:condition, :contains_body, body: "soon")
        ]
      )

      expect(object).to receive(:condition_attribute)
        .with("subject").and_return("Welcome!")
      expect(object).to receive(:condition_attribute)
        .with("body").and_return("Hello, we hope to see you soon!")

      expect(condition_group.satisfied_by?(object)).to eq(true)
    end
  end
end
