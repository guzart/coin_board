class CreateMessageConditionGroup < ActiveRecord::Migration[7.1]
  def change
    create_table :message_condition_groups do |t|
      t.references :user, null: false, foreign_key: true
      t.string :logical_operator, null: false

      t.timestamps
    end
  end
end
