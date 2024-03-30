class RenameMailboxMessageParserToMailboxMessageDispatcher < ActiveRecord::Migration[7.1]
  def change
    rename_table :mailbox_message_parsers, :mailbox_message_dispatchers
  end
end
