class HomeController < ApplicationController
  allow_anonymous_access!

  def index
    redirect_to current_user_root_path if current_user
  end
end
