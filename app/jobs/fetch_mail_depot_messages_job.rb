class FetchMailDepotMessagesJob < ApplicationJob
  queue_as :default

  def perform
    messages_uids = MailDepot::Client.instance.find_messages_uids(count: 100)
    messages_uids.each do |message_uid|
      DistributeMessageJob.perform_later message_uid
    end
  end
end
