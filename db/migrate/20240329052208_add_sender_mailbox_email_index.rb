class AddSenderMailboxEmailIndex < ActiveRecord::Migration[7.1]
  def change
    add_index :senders, [:mailbox_id, :email], unique: true
  end
end
