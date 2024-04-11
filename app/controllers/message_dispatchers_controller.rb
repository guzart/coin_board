class MessageDispatchersController < ApplicationController
  load_and_authorize_resource
  before_action :load_currencies, only: %i[index show create update]

  def index
    @message_dispatcher = MessageDispatcher.new
  end

  def show
    @senders = Sender.accessible_by(current_ability)
  end

  def create
    redirect_to message_dispatcher_path(@message_dispatcher) if @message_dispatcher.save

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream
    end
  end

  def update
    redirect_to message_dispatcher_path(@message_dispatcher) if @message_dispatcher.update(message_dispatcher_params)

    respond_to do |format|
      format.html { render :show }
      format.turbo_stream
    end
  end

  def destroy
    @message_dispatcher.destroy
    redirect_to message_dispatchers_path, status: :see_other
  end

  private

  def message_dispatcher_params
    params.require(:message_dispatcher).permit(:name, :currency_id)
  end

  def load_currencies
    @currencies = Currency.accessible_by(current_ability)
  end
end
