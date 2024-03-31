module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!

    private

    def after_sign_in_path_for(resource)
      user_path(resource)
    end

    def redirect_authenticated_user
      redirect_to after_sign_in_path_for(current_user) if user_signed_in?
    end
  end

  class_methods do
    def allow_anonymous_access!
      skip_before_action :authenticate_user!
    end

    def redirect_authenticated_user!
      before_action :redirect_authenticated_user
    end
  end
end
