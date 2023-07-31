class AuthController < ApplicationController

  def login

  end

  def register

  end

  private

  def auth_params
    params.permit(:email, :phone, :password)
  end

end
