class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery with: :exception

  helper_method :current_mailbox

  private

  def current_mailbox
    current_user&.mailbox
  end
end
