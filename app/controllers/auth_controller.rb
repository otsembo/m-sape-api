require_relative '../../lib/repository/user_repo'
require_relative '../../lib/auth/m_sape'
require_relative '../../lib/app_error'

class AuthController < ApplicationController

  def initialize
    @user_repo = UserRepo.new
    @auth = Authentication.new
  end

  def login
    data = @user_repo.search_user(email:auth_params[:email])
    unless data
      invalid_record( AppError.new("that user does not exist") )
      return
    end
    @user_repo.login(user:data, password: auth_params[:password]) ?
      app_response(body: { auth: @auth.jwt_encode(payload: { uid: data.id }) }, message: "", status: 200) :
      invalid_record( AppError.new("that password is incorrect") )
  end

  def register
    data = @user_repo.create_account(
      email: auth_params[:email],
      password: auth_params[:password],
      phone: auth_params[:phone]
    )
    if data.valid?
      token = @auth.jwt_encode(payload: { uid: data.id })
      app_response(body: { auth: token }, message: 'created account successfully', status: 201)
    end
    invalid_record(data)
  end

  private

  def auth_params
    params.permit(:email, :phone, :password)
  end

end
