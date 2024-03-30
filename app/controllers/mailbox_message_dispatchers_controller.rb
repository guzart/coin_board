class MailboxMessageDispatchersController < ApplicationController
  load_and_authorize_resource

  def index
    @mailbox_message_dispatcher = MailboxMessageDispatcher.new
  end

  def show; end

  def create
    redirect_to mailbox_message_dispatcher_path(@mailbox_message_dispatcher) if @mailbox_message_dispatcher.save

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream
    end
  end

  def destroy
    @mailbox_message_dispatcher.destroy
    redirect_to mailbox_message_dispatchers_path, status: :see_other
  end

  private

  def mailbox_message_dispatcher_params
    params.require(:mailbox_message_dispatcher).permit(:name)
  end
end
