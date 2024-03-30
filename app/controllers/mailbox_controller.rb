class MailboxController < ApplicationController
  before_action :set_mailbox
  load_and_authorize_resource

  def show; end

  private

  def set_mailbox
    @mailbox = Mailbox.includes(:mailbox_senders).find_by(user: current_user)
  end
end
