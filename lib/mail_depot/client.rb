require "net/imap"
require_relative "extensions/mail"

module MailDepot
  class Client
    include Singleton

    include Config
    include Constants
    include Logger

    def initialize
      @imap_pool = ConnectionPool.new(size: 2) { Connection.new }
      at_exit { @imap_pool.shutdown(&:logout) }
    end

    def with_inbox
      @imap_pool.with do |conn|
        conn.with_imap do |imap|
          imap.select(INBOX)
          yield imap if block_given?
        end
      end
    end

    def find_emails_uids(count: 100)
      logger.debug "Fetching #{count} emails from MailDepot"
      with_inbox do |imap|
        uids = imap.uid_search(ALL)
        logger.debug "Found #{uids.size} emails"
        uids.first(count)
      end
    end

    def find_emails(count = 10)
      with_inbox do |imap|
        uids = imap.uid_search(ALL)
        uids.first(count).map do |uid|
          fetch_data = imap.uid_fetch(uid, [RFC822])[0]
          build_rfcs822_email(fetch_data)
        end
      end
    end

    def find_email(uid)
      with_inbox do |imap|
        fetch_data = imap.uid_fetch(uid, [RFC822])[0]
        build_rfcs822_email(fetch_data)
      end
    end

    def delete_email(uid)
      with_inbox do |imap|
        imap.uid_store(uid, "+FLAGS", [Net::IMAP::DELETED])
        imap.expunge
      end
    end

    def detached_listen_for_mail(&block)
      @you_got_mail_callback = block
      pid = fork do
        conn = Connection.new
        check_for_existing_mail(conn)
        loop { wait_for_mail(conn) }
        conn.logout
      end
      Process.detach(pid)
    end

    private

    def build_rfcs822_email(fetch_data)
      return nil if fetch_data.nil?

      ::Mail.new(fetch_data.attr[RFC822]).tap do |msg|
        msg.uid = fetch_data.uid
      end
    end

    def check_for_existing_mail(conn)
      response = conn.with_imap do |imap|
        imap.status(INBOX, [MESSAGES, RECENT])
      end
      email_count = response[MESSAGES]
      @you_got_mail_callback&.call if email_count.positive?
    end

    def wait_for_mail(conn)
      conn.with_imap do |imap|
        imap.select(INBOX)
        imap.idle(60) do |response|
          @you_got_mail_callback&.call unless idle_response?(response)
        end
      end
    end

    def idle_response?(response)
      return true if response.is_a?(Net::IMAP::ContinuationRequest)
      return true if response.is_a?(Net::IMAP::UntaggedResponse) && response.name == OK

      false
    end
  end
end
