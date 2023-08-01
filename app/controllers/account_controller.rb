class AccountController < ApplicationController
  before_action :auth_request

  def index
    app_response(body: nil, status: 200, message: 'success')
  end

end
