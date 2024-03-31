class MailboxController < ApplicationController
  load_and_authorize_resource

  def show
    @needs_sender_approval = @mailbox.senders.pending.exists?
    @needs_message_dispatchers = MessageDispatcher.accessible_by(current_ability).empty?
  end
end
