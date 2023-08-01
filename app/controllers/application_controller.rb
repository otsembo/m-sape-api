class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_missing
  # rescue_from ActiveRecord::RecordInvalid, with: :invalid_record


  def home
    app_response(body: 'Welcome to m-sape', status: 200, message: 'success' )
  end

  # app constants
  def app_response(body:, status:, message:)
    success = [200, 201].include? status
    render json: {
      message: success ? 'success' : message,
      status: status,
      data:  body,
    }, status: status
  end

  def not_found(body: nil, message:)
    app_response(body: body, status: 404, message: message)
  end

  def invalid_record(data)
    app_response(body: { errors: data.errors }, status: 403, message: 'Invalid data')
  end

  private

  def record_missing(e)
    not_found(body: e, message: 'Record not found')
  end

end
