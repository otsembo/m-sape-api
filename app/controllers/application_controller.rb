class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_missing




  private

  def record_missing(e)
    not_found(body: e, message: 'Record not found')
  end

  # app constants
  def app_response(body:, status:, message:)
    success = [200, 201].include? status
      render json: {
        message: message,
        status: status,
        data:  success ? body : nil,
      }, status: status
  end

  def not_found(body: nil, message:)
    app_response(body: body, status: 404, message: message)
  end

end
