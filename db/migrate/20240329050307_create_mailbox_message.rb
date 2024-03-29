class CreateMailboxMessage < ActiveRecord::Migration[7.1]
  def change
    create_table :mailbox_messages do |t|
      t.references :mailbox_sender, null: false, foreign_key: true
      t.bigint :uid, null: false
      t.string :message_id
      t.text :body, null: false
      t.string :content_type, null: false

      t.timestamps
    end
  end
end
