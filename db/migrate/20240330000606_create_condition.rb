class CreateCondition < ActiveRecord::Migration[7.1]
  def change
    create_table :conditions do |t|
      t.references :condition_group, null: false, foreign_key: true
      t.string :comparison_operator, null: false
      t.string :comparison_value
      t.string :lower_bound
      t.string :upper_bound

      t.timestamps
    end
  end
end
