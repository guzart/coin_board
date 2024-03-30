class CreateConditionGroup < ActiveRecord::Migration[7.1]
  def change
    create_table :condition_groups do |t|
      t.references :user, null: false, foreign_key: true
      t.string :logical_operator, null: false
      t.references :parent_condition_group, null: true, foreign_key: { to_table: :condition_groups }

      t.timestamps
    end
  end
end
