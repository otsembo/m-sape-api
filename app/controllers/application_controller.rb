require_relative '../../lib/auth/m_sape'

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_missing
  rescue_from JWT::DecodeError, JWT::ExpiredSignature, JWT::EncodeError, with: :jwt_error
  rescue_from ActionController::RoutingError, with: :missing_page

  def initialize
    @auth = Authentication.new
  end

  def home
    app_response(body: 'Welcome to m-sape', status: 200, message: 'success' )
  end

  def missing_route
    app_response(body: 'Missing route', status: 404, message: 'You seem lost')
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
    app_response(body: { errors: data.errors }, status: 422, message: 'Invalid data')
  end

  # auth pre-request
  def auth_request
    headers = request.headers['Authorization']
    token = headers ? headers.split(' ').last : nil
    @auth = Authentication.new
    unless token && @auth.jwt_decode(token: token)
      app_response(body: { errors: ['You are not authorized to view this page. Check your authorization header and try again'] },
                   status: 403,
                   message: 'failed')
    end
  end

  def uid
    @auth.jwt_decode(token: request.headers['Authorization'].split(' ').last)[0]["data"]["uid"].to_i
  end

  private

  def record_missing(e)
    not_found(body: e, message: 'Record not found')
  end

  def jwt_error(e)
    app_response(body: e, message: 'Authorization error', status: 403)
  end

  def missing_page(e)
    pp { :hello => "world" }
    app_response(body: e, message: 'you seem lost', status: 404)
  end

end
