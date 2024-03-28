class CreateMailboxes < ActiveRecord::Migration[7.1]
  def change
    create_table :mailboxes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :email, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
