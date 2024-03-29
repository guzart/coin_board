class RouteMessageJob < ApplicationJob
  queue_as :default

  NoMessagePartFound = Class.new(StandardError)

  def perform(message_uid)
    find_and_set_message(message_uid)
    route_message_to_mailboxes
    delete_message
  end

  private

  attr_reader :message

  def find_and_set_message(message_uid)
    @message = MailDepot::Client.instance.find_message(message_uid)
    raise "Message with uid #{message_uid} not found" if message.nil?

    logger.info "Routing message from #{message.from} to #{message.to} with subject: #{message.subject}"
  end

  def route_message_to_mailboxes
    Mailbox.where(email: recipient_emails).find_each do |mailbox|
      mailbox_sender = mailbox.mailbox_senders.create_or_find_by!(email: sender_email)
      mailbox_message = create_mailbox_message(mailbox_sender)
      ParseMessageJob.perform_later(mailbox_message) if mailbox_sender.allowed?
    rescue NoMessagePartFound
      msg_details = "message #{message_uid} from #{message.from} with subject: #{message.subject}"
      logger.error "No message part found for #{msg_details}"
    end
  end

  def delete_message
    MailDepot::Client.instance.delete_message(message.uid)
  end

  def recipient_emails
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
      mailbox_message.attributes = mailbox_message_content_attrs.merge(message_id: message.message_id)
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
end
