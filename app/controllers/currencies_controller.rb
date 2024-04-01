class CurrenciesController < ApplicationController
  load_and_authorize_resource

  def index; end

  def create
    return redirect_to(currencies_path) if @currency.save

    @form_name = params[:form_name]
  end

  def destroy
    @currency.destroy
    redirect_to currencies_path, status: :see_other
  end

  private

  def currency_params
    params.require(:currency).permit(:iso_code, :name, :symbol, :subunit_to_unit, :decimal_mark, :thousands_separator)
  end
end
