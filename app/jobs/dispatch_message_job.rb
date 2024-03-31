class DispatchMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    @message = message

    message_dispatchers.each do |message_dispatcher|
      next unless message_dispatcher.matches_message?(message)

      # 1. parse message (account, amount, date?, payee?)
      # 2. enqueue create payment transaction
      # 3. destroy message
      # raise NotImplementedError
    end
  end

  private

  def user
    @message.user
  end

  def message_dispatchers
    user.message_dispatchers
  end
end
