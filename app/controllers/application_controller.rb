# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  respond_to :json

  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do |error|
    render 'shared/error', status: :not_found, locals: { detail: error }
  end

  rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed do |error|
    render 'shared/active_record_error', status: :unprocessable_entity,
                                         locals: { detail: error.record.errors.messages }
  end
end
