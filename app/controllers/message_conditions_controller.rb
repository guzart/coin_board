class MessageConditionsController < ApplicationController
  load_and_authorize_resource

  def create
    @senders = Sender.accessible_by(current_ability)
    return unless @message_condition.save

    redirect_to message_dispatcher_path(@message_condition.message_dispatcher)
  end

  def destroy
    @message_condition.destroy
    redirect_to message_dispatcher_path(@message_condition.message_dispatcher), status: :see_other
  end

  private

  def message_condition_params
    params.require(:message_condition).permit(:message_condition_group_id, :comparison_attribute, :comparison_operator,
                                              :comparison_value, :sender_id)
  end
end
