module MailDepot
  module Config
    extend ActiveSupport::Concern

    included do
      def server_address
        ENV.fetch("MAILBOX_IMAP_ADDRESS")
      end

      def server_port
        993
      end

      def username
        ENV.fetch("MAILBOX_IMAP_USERNAME")
      end

      def password
        ENV.fetch("MAILBOX_IMAP_PASSWORD")
      end

      def enable_starttls
        false
      end
    end
  end
end
