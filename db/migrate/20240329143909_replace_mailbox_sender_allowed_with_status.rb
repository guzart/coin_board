class ReplaceMailboxSenderAllowedWithStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :mailbox_senders, :status, :integer, default: 0, null: false
    remove_column :mailbox_senders, :allowed, :boolean, default: false, null: false
  end
end
