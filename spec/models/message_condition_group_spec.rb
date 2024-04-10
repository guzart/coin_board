# == Schema Information
#
# Table name: message_condition_groups
#
#  id                    :integer          not null, primary key
#  logical_operator      :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  message_dispatcher_id :integer          not null
#
# Indexes
#
#  index_message_condition_groups_on_message_dispatcher_id  (message_dispatcher_id)
#
# Foreign Keys
#
#  message_dispatcher_id  (message_dispatcher_id => message_dispatchers.id)
#
require "rails_helper"

RSpec.describe MessageConditionGroup, type: :model do
  it "validates the logical operator" do
    condition_group = build(:message_condition_group, logical_operator: "INVALID")
    expect(condition_group).not_to be_valid
    expect(condition_group.errors[:logical_operator]).to include("is not included in the list")
  end

  describe "#satisfied_by?" do
    it "evaluates the logical operator AND" do
      object = double("Object")
      condition_group = build(
        :message_condition_group,
        logical_operator: "AND",
        message_conditions: [
          build(:message_condition, :exactly_matches_subject, subject: "Welcome!"),
          build(:message_condition, :contains_body, body: "soon")
        ]
      )

      expect(object).to receive(:condition_attribute)
        .with(:subject).and_return("Welcome!")
      expect(object).to receive(:condition_attribute)
        .with(:body).and_return("Hello, we hope to see you soon!")

      expect(condition_group.satisfied_by?(object)).to eq(true)
    end
  end
end
