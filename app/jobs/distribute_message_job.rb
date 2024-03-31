class DistributeMessageJob < ApplicationJob
  queue_as :default

  EmailNotFound = Class.new(StandardError)
  NoEmailPartFound = Class.new(StandardError)
  UnauthenticatedEmail = Class.new(StandardError)

  def perform(email_uid)
    find_mail_depot_email(email_uid)
    validated_authenticated_email!
    route_mail_depot_email_to_mailboxes
    delete_mail_depot_email
  rescue NoEmailPartFound, UnauthenticatedEmail => e
    logger.info e.message
    delete_mail_depot_email
  rescue EmailNotFound => e
    logger.info e.message
  end

  private

  attr_reader :email

  def find_mail_depot_email(email_uid)
    @email = MailDepot::Client.instance.find_email(email_uid)
    raise EmailNotFound, "Email with uid #{email_uid} not found" if email.nil?

    logger.info "Routing email from #{email.from} to #{email.to} with subject: #{email.subject}"
  end

  def validated_authenticated_email!
    raise UnauthenticatedEmail unless email.authenticated?
  end

  def route_mail_depot_email_to_mailboxes
    recipients_mailboxes.find_each do |mailbox|
      sender = mailbox.senders.create_or_find_by!(email: sender_email)
      message = create_message(sender)
      DispatchMessageJob.perform_later(message) if sender.approved?
    end
  end

  def delete_mail_depot_email
    notify_email_dropped if recipients_mailboxes.empty?
    MailDepot::Client.instance.delete_email(email.uid)
  end

  def recipients_mailboxes
    Mailbox.where(email: recipients_emails)
  end

  def recipients_emails
    recipients = email.to
    recipients += email.cc if email.cc.present?
    recipients += email.bcc if email.bcc.present?
    recipients.map(&Utils::EmailNormalizer.method(:normalize))
  end

  def sender_email
    Utils::EmailNormalizer.normalize(email.from.first)
  end

  def create_message(sender)
    sender.messages.find_or_create_by!(uid: email.uid) do |message|
      other_attrs = { email_id: email.message_id, subject: email.subject }
      message.attributes = message_content_attrs.merge(other_attrs)
    end
  end

  def message_content_attrs
    content_type = Message::HTML_CONTENT_TYPE
    email_part = email.parts.find { |part| part.content_type =~ /html/ }

    if email_part.nil?
      content_type = Message::PLAIN_CONTENT_TYPE
      email_part = email.parts.find { |part| part.content_type =~ /plain/ }
    end

    raise NoEmailPartFound, "Email does not have a plain or html content part" if email_part.blank?

    { body: decode_body(email_part), content_type: }
  end

  def decode_body(email_part)
    email_part.decode_body.force_encoding("UTF-8").encode("UTF-8", invalid: :replace, undef: :replace, replace: "⍰")
  end

  def notify_email_dropped
    logger.info "Email dropped: #{email_details}"
  end

  def email_details
    "Email #{email.uid} from #{email.from} with subject: #{email.subject}"
  end
end
