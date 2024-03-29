class UpdateMailboxSenderIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :mailbox_senders, :email
    add_index :mailbox_senders, [:mailbox_id, :email], unique: true
  end
end
