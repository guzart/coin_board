class CreateMessageDispatcher < ActiveRecord::Migration[7.1]
  def change
    create_table :message_dispatchers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.references :message_condition_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
