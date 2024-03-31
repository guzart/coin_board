class MessageConditionsController < ApplicationController
  load_and_authorize_resource

  def create
    return unless @message_condition.save

    @message_condition = MessageCondition.new(message_condition_group: @message_condition.message_condition_group)
  end

  private

  def message_condition_params
    params.require(:message_condition).permit(:message_condition_group_id, :comparison_attribute, :comparison_operator,
                                              :comparison_value, :sender_id)
  end
end
