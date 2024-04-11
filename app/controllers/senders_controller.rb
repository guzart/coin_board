class SendersController < ApplicationController
  load_and_authorize_resource

  def index; end

  def show; end

  def approve
    @sender.approve!
    redirect_to senders_path
  end

  def block
    @sender.block!
    redirect_to senders_path
  end

  def dispatch_messages
    @sender.dispatch_messages
    redirect_to sender_path(@sender)
  end
end
