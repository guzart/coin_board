module MailboxSenderHelper
  def mailbox_sender_approve_button(mailbox_sender, options = {})
    ButtonComponent.new("Approve", href: approve_mailbox_sender_path(mailbox_sender),
                                   data: { turbo_method: :post }, variant: :info, **options)
  end

  def mailbox_sender_block_button(mailbox_sender, options = {})
    ButtonComponent.new("Block", href: block_mailbox_sender_path(mailbox_sender),
                                 data: { turbo_method: :post }, variant: :danger, outline: true, **options)
  end

  def mailbox_sender_status_badge(mailbox_sender)
    if mailbox_sender.approved?
      StatusBadgeComponent.new("Approved", variant: :success)
    elsif mailbox_sender.blocked?
      StatusBadgeComponent.new("Blocked", variant: :danger)
    elsif mailbox_sender.pending?
      StatusBadgeComponent.new("Pending approval", variant: :info)
    else
      { inline: "" }
    end
  end
end
