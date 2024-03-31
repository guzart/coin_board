class HomeController < ApplicationController
  allow_anonymous_access!
  redirect_authenticated_user!

  def index; end
end
