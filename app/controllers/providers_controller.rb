class ProvidersController < ApplicationController
  load_and_authorize_resource
  before_action :validate_state!, only: :oauth_callback

  OAUTH_STATE_SESSION_KEY = :oauth_state
  private_constant :OAUTH_STATE_SESSION_KEY

  def index; end

  def show
    state = Base64.urlsafe_encode64(JSON.generate(id: @provider.id, nonce: SecureRandom.hex(8)))
    session[OAUTH_STATE_SESSION_KEY] = state
    @oauth_authorize_url = @provider.oauth_authorize_url(state: session[OAUTH_STATE_SESSION_KEY])
  end

  def create
    return redirect_to(provider_path(@provider)) if @provider.save

    @form_name = params[:form_name]
  end

  def destroy
    @provider.destroy
    redirect_to providers_path, status: :see_other
  end


  def oauth_callback
    state = fetch_state_from_session
    provider = Provider.find(state["id"])
    authorize! :edit, provider

    result = provider.oauth_authorize!(code: params[:code], state: params[:state])
    if result.success?
      redirect_to provider_path(provider), notice: "Connected to #{provider.name}"
    else
      redirect_to provider_path(provider), alert: result.failure
    end
  end
  private

  def fetch_state_from_session
    JSON.parse(Base64.urlsafe_decode64(session.delete(OAUTH_STATE_SESSION_KEY)))
  end

  def validate_state!
    return unless session[OAUTH_STATE_SESSION_KEY] != params[:state]

    session.delete(OAUTH_STATE_SESSION_KEY)
    redirect_to providers_path, alert: "Invalid state"
  end

  def provider_params
    params.require(:provider).permit(:name)
  end
end
