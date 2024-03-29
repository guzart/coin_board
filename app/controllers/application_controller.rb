class ApplicationController < ActionController::Base
  include Authentication

  helper_method :current_user_root_path

  private

  def current_user_root_path
    mailbox_path(current_user.mailbox)
  end
end
