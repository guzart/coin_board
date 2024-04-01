class AddStatusToMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :status, :integer, null: false, default: 0
  end
end
