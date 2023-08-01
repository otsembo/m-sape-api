require_relative '../../lib/repository/user_repo'
require_relative '../../lib/auth/m_sape'

class AuthController < ApplicationController

  def initialize
    @user_repo = UserRepo.new
    @auth = Authentication.new
  end

  def login

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
    else
      app_response(body: { errors: data.errors }, message: 'failed', status: 403)
    end
  end

  private

  def auth_params
    params.permit(:email, :phone, :password)
  end

end
