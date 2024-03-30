class CreateMailboxMessageParser < ActiveRecord::Migration[7.1]
  def change
    create_table :mailbox_message_parsers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.references :match_condition_group, null: false, foreign_key: { to_table: :condition_groups }

      t.timestamps
    end
  end
end
