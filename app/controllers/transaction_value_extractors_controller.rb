class TransactionValueExtractorsController < ApplicationController
  load_and_authorize_resource

  def create
    return unless @transaction_value_extractor.save

    redirect_to message_dispatcher_path(@transaction_value_extractor.message_dispatcher)
  end

  def destroy
    @transaction_value_extractor.destroy
    redirect_to message_dispatcher_path(@transaction_value_extractor.message_dispatcher), status: :see_other
  end

  private

  def transaction_value_extractor_params
    params.require(:transaction_value_extractor)
          .permit(:message_dispatcher_id, :field, :extraction_type, :extraction_value).to_h.tap do |data|
      data[:field] = data[:field].to_i
      data[:extraction_type] = data[:extraction_type].to_i
    end
  end
end
