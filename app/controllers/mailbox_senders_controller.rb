class MailboxSendersController < ApplicationController
  load_and_authorize_resource

  def approve
    @mailbox_sender.approve!
    redirect_to current_user_root_path
  end

  def block
    @mailbox_sender.block!
    redirect_to current_user_root_path
  end
end
