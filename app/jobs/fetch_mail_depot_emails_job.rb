class FetchMailDepotEmailsJob < ApplicationJob
  queue_as :default

  def perform
    emails_uids = MailDepot::Client.instance.find_emails_uids(count: 100)
    emails_uids.each do |email_uid|
      DistributeMessageJob.perform_later email_uid
    end
  end
end
