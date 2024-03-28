class CreateMailboxSenders < ActiveRecord::Migration[7.1]
  def change
    create_table :mailbox_senders do |t|
      t.references :mailbox, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false, index: true
      t.boolean :allowed, null: false, default: false

      t.timestamps
    end
  end
end
