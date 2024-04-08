class DispatchMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    @message = message

    if matching_message_dispatchers.empty?
      @message.no_dispatcher!
    else
      process_message_dispatchers
      @message.dispatched!
    end
  end

  private

  def matching_message_dispatchers
    @matching_message_dispatchers ||= message_dispatchers.select do |message_dispatcher|
      message_dispatcher.matches_message?(@message)
    end
  end

  def process_message_dispatchers
    matching_message_dispatchers.each do |message_dispatcher|
      transaction = message_dispatcher.extract_transaction(@message)
      next if transaction.empty?

      message_dispatcher.dispatch_transaction(transaction)
    end
  end

  def message_dispatchers
    @message.user.message_dispatchers
  end
end
