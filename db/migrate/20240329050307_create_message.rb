class CreateMessage < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :sender, null: false, foreign_key: true
      t.bigint :uid
      t.string :email_id
      t.datetime :sent_at
      t.string :subject
      t.text :body
      t.string :content_type

      t.timestamps
    end
  end
end
