module MailDepot
  module Logger
    extend ActiveSupport::Concern

    included do
      def logger
        @logger ||= ::Logger.new($stdout).tap do |logger|
          logger.level = ::Logger::DEBUG
        end
      end

      def logger=(logger)
        @logger = logger
      end
    end
  end
end
