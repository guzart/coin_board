class DispatchMessageJob < ApplicationJob
  queue_as :default

  def perform(mailbox_message)
    @mailbox_message = mailbox_message

    mailbox_message_dispatchers.each do |dispatcher|
      next unless dispatcher.matches_mailbox_message?(mailbox_message)

      # 1. parse message (account, amount, date?, payee?)
      # 2. enqueue create payment transaction
      # 3. destroy message
      # raise NotImplementedError
    end
  end

  private

  def user
    @mailbox_message.user
  end

  def mailbox_message_dispatchers
    user.mailbox_message_dispatchers
  end
end
