module MailboxSenderHelper
  def mailbox_sender_approve_button(mailbox_sender, options = {})
    ButtonComponent.new("Approve", href: approve_mailbox_sender_path(mailbox_sender),
                                   data: { turbo_method: :post }, variant: :info, **options)
  end

  def mailbox_sender_block_button(mailbox_sender, options = {})
    ButtonComponent.new("Block", href: block_mailbox_sender_path(mailbox_sender),
                                 data: { turbo_method: :post }, variant: :danger, outline: true, **options)
  end
end
