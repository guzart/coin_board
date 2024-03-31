class AddComparisonAttributeToCondition < ActiveRecord::Migration[7.1]
  def change
    add_column :conditions, :comparison_attribute, :string
  end
end
