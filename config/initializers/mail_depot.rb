Rails.configuration.after_initialize do
  if Rails.const_defined? "Server"
    MailDepot::Client.instance.detached_wait_for_mail do
      FetchMailDepotMessagesJob.perform_now
    end
  end
end
