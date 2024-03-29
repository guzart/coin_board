class MailboxSendersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def approve
    @mailbox_sender.approve!
    redirect_to mailbox_senders_path
  end

  def block
    @mailbox_sender.block!
    redirect_to mailbox_senders_path
  end
end
