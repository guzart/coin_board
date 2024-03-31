class ApplicationController < ActionController::Base
  include Authentication

  helper_method :current_mailbox

  private

  def current_mailbox
    current_user&.mailbox
  end
end
