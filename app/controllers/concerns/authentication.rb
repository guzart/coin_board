module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!

    def after_sign_in_path_for(resource)
      user_path(resource)
    end
  end

  class_methods do
    def allow_anonymous_access!
      skip_before_action :authenticate_user!
    end
  end
end
