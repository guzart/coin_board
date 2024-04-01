Rails.configuration.after_initialize do
  if Rails.const_defined?("Server") && ENV.fetch("MAIL_DEPOT_LISTEN_ENABLED", "false") == "true"
    MailDepot::Client.instance.detached_listen_for_mail do
      FetchMailDepotEmailsJob.perform_later
    end
  end
end
