class MailboxMessageParsersController < ApplicationController
  load_and_authorize_resource

  def index
    @mailbox_message_parser = MailboxMessageParser.new
  end

  def show; end

  def create
    redirect_to mailbox_message_parser_path(@mailbox_message_parser) if @mailbox_message_parser.save

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream
    end
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
