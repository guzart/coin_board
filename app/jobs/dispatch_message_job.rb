class DispatchMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    @message = message

    message_dispatchers.each do |message_dispatcher|
      next unless message_dispatcher.matches_message?(message)

      # 1. parse transaction from message (amount, date?, payee?)
      # 2. dispatch transaction to provider
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
