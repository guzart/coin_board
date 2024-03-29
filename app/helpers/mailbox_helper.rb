module MailboxHelper
  def mailbox_senders_pending_approval(mailbox)
    mailbox.mailbox_senders.select(&:pending?)
  end
end
