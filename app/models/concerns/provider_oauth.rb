module ProviderOauth
  extend ActiveSupport::Concern

  included do
    def oauth_authorize_url(state:)
      redirect_url = oauth_redirect_url(state:)
      provider_instance.oauth_authorize_url(redirect_url:)
    end

    def oauth_authorize!(code:, state:)
      redirect_url = oauth_redirect_url(state:)
      provider_instance.oauth_authorize!(code:, redirect_url:).tap do
        update_provider_settings!
      end
    end

    def oauth_redirect_url(state:)
      url_helpers = Rails.application.routes.url_helpers
      url_options = Rails.application.config.action_mailer.default_url_options
      url_helpers.oauth_callback_providers_url(state:, **url_options)
    end
  end
end
