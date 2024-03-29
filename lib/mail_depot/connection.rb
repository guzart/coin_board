module MailDepot
  class Connection
    include Config
    include Constants
    include Logger

    def initialize
      initialize_imap
    end

    def with_imap(&block)
      check_connection
      retry_on_failure(&block)
    end

    def logout
      return unless @logged_in

      unless @imap.disconnected?
        logger.debug "Logging out..."
        @imap.logout
      end

      @logged_in = false
    end

    private

    def retry_on_failure(&block)
      retries = 0
      loop do
        break if retries >= 1

        logger.debug "Running block with imap connection..."
        return block.call(@imap) if block_given?
      rescue Net::IMAP::NoResponseError, Net::IMAP::ByeResponseError
        reload
        retries += 1
      end

      result
    end

    def check_connection
      reload if @imap.disconnected?
      login
    end

    def reload
      logger.debug "Reloading..."
      initialize_imap
      login
    end

    def initialize_imap
      logger.debug "Initializing IMAP..."
      logout
      @imap = Net::IMAP.new(server_address, port: server_port, ssl: true)
    end

    def login
      return if @logged_in

      logger.debug "Logging in..."
      @imap.starttls if enable_starttls
      @imap.login(username, password)
      @logged_in = true
      logger.debug "Logged in"
    end
  end
end
