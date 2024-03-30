class DistributeMessageJob < ApplicationJob
  queue_as :default

  NoMessagePartFound = Class.new(StandardError)

  def perform(message_uid)
    find_mail_depot_message(message_uid)
    validate_mail_depot_message
    route_mail_depot_message_to_mailboxes
    delete_mail_depot_message
  end

  private

  attr_reader :message

  def find_mail_depot_message(message_uid)
    @message = MailDepot::Client.instance.find_message(message_uid)
    raise "Message with uid #{message_uid} not found" if message.nil?

    logger.info "Routing message from #{message.from} to #{message.to} with subject: #{message.subject}"
  end

  def validate_mail_depot_message
    # TODO: validate either SPF or DKIM pass
  end

  def route_mail_depot_message_to_mailboxes
    recipients_mailboxes.find_each do |mailbox|
      mailbox_sender = mailbox.mailbox_senders.create_or_find_by!(email: sender_email)
      mailbox_message = create_mailbox_message(mailbox_sender)
      ParseMessageJob.perform_later(mailbox_message) if mailbox_sender.approved?
    rescue NoMessagePartFound
      logger.error "No message parts found: #{message_details}"
    end
  end

  def recipients_mailboxes
    Mailbox.where(email: recipients_emails)
  end

  def delete_mail_depot_message
    notify_message_dropped if recipients_mailboxes.empty?
    MailDepot::Client.instance.delete_message(message.uid)
  end

  def recipients_emails
    recipients = message.to
    recipients += message.cc if message.cc.present?
    recipients += message.bcc if message.bcc.present?
    recipients.map(&Utils::EmailNormalizer.method(:normalize))
  end

  def sender_email
    Utils::EmailNormalizer.normalize(message.from.first)
  end

  def create_mailbox_message(mailbox_sender)
    mailbox_sender.mailbox_messages.find_or_create_by!(uid: message.uid) do |mailbox_message|
      mailbox_message.attributes = mailbox_message_content_attrs.merge(message_id: message.message_id,
                                                                       subject: message.subject)
    end
  end

  def mailbox_message_content_attrs
    content_type = MailboxMessage::HTML_CONTENT_TYPE
    msg_part = message.parts.find { |part| part.content_type =~ /html/ }

    if msg_part.nil?
      content_type = MailboxMessage::PLAIN_CONTENT_TYPE
      msg_part = message.parts.find { |part| part.content_type =~ /plain/ }
    end

    raise NoMessagePartFound if msg_part.blank?

    { body: decode_body(msg_part), content_type: }
  end

  def decode_body(msg_part)
    msg_part.decode_body.force_encoding("UTF-8").encode("UTF-8", invalid: :replace, undef: :replace, replace: "⍰")
  end

  def notify_message_dropped
    logger.info "Message dropped: #{message_details}"
  end

  def message_details
    "Message #{message_uid} from #{message.from} with subject: #{message.subject}"
  end
end
