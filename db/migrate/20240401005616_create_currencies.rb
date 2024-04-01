class CreateCurrencies < ActiveRecord::Migration[7.1]
  def change
    create_table :currencies do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :iso_code
      t.string :symbol
      t.integer :subunit_to_unit
      t.string :decimal_mark
      t.string :thousands_separator

      t.timestamps
    end
  end
end
