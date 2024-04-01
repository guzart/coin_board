class AddCurrencyToMessageDispatcher < ActiveRecord::Migration[7.1]
  def change
    add_reference :message_dispatchers, :currency, null: false, foreign_key: true
  end
end
