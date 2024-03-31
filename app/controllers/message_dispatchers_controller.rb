class MessageDispatchersController < ApplicationController
  load_and_authorize_resource

  def index
    @message_dispatcher = MessageDispatcher.new
  end

  def show; end

  def create
    redirect_to message_dispatcher_path(@message_dispatcher) if @message_dispatcher.save

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream
    end
  end

  def destroy
    @message_dispatcher.destroy
    redirect_to message_dispatchers_path, status: :see_other
  end

  private

  def message_dispatcher_params
    params.require(:message_dispatcher).permit(:name)
  end
end
