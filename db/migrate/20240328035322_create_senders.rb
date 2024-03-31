class CreateSenders < ActiveRecord::Migration[7.1]
  def change
    create_table :senders do |t|
      t.references :mailbox, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
