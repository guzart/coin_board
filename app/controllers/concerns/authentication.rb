module Authentication
  extend ActiveSupport::Concern

  included { before_action :authenticate_user! }

  class_methods do
    def allow_anonymous_access!
      skip_before_action :authenticate_user!
    end
  end
end
