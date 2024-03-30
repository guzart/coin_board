class MailboxMessageParsersController < ApplicationController
  load_and_authorize_resource

  def index; end

  def show; end

  def create
    @mailbox_message_parser.user = current_user
    @mailbox_message_parser.save!
    redirect_to mailbox_message_parser_path(@mailbox_message_parser)
  end

  def destroy
    @mailbox_message_parser.destroy
    redirect_to mailbox_message_parsers_path, status: :see_other
  end

  private

  def mailbox_message_parser_params
    params.require(:mailbox_message_parser).permit(:name)
  end
end
