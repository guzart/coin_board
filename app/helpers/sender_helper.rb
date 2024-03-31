module SenderHelper
  def sender_approve_button(sender, options = {})
    ButtonComponent.new("Approve", href: approve_sender_path(sender),
                                   data: { turbo_method: :post }, variant: :info, **options)
  end

  def sender_block_button(sender, options = {})
    ButtonComponent.new("Block", href: block_sender_path(sender),
                                 data: { turbo_method: :post }, variant: :danger, outline: true, **options)
  end

  def sender_status_badge(sender)
    if sender.approved?
      StatusBadgeComponent.new("Approved", variant: :success)
    elsif sender.blocked?
      StatusBadgeComponent.new("Blocked", variant: :danger)
    elsif sender.pending?
      StatusBadgeComponent.new("Pending approval", variant: :info)
    else
      { inline: "" }
    end
  end
end
