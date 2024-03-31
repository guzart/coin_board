class CreateMessageCondition < ActiveRecord::Migration[7.1]
  def change
    create_table :message_conditions do |t|
      t.references :message_condition_group, null: false, foreign_key: true
      t.string :comparison_attribute
      t.string :comparison_operator
      t.string :comparison_value
      t.references :sender, null: true, foreign_key: true

      t.timestamps
    end
  end
end
