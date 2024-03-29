class AddSubjectToMailboxMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :mailbox_messages, :subject, :string
  end
end
