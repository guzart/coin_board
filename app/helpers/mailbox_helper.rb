module MailboxHelper
  def mailbox_senders_pending_approval(mailbox)
    mailbox.senders.select(&:pending?)
  end
end
