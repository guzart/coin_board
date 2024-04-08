class CreateTransactionValueExtractors < ActiveRecord::Migration[7.1]
  def change
    create_table :transaction_value_extractors do |t|
      t.references :message_dispatcher, null: false, foreign_key: true
      t.integer :field
      t.integer :extraction_type
      t.string :extraction_value

      t.timestamps
    end
  end
end
