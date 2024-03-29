class ParseMessageJob < ApplicationJob
  queue_as :default

  def perform(mailbox_message)
    # 1. parse message (account, amount, date?, payee?)
    # 2. enqueue create payment transaction
    # 3. destroy message
  end
end
