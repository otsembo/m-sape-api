require_relative '../../lib/repository/account_repo'

class AccountController < ApplicationController
  before_action :auth_request

  def initialize
    @amount = 0.0
    @account_repo = AccountRepo.new
  end

  def index
    app_response(body: nil, status: 200, message: 'success')
  end

  def topup
    @amount = topup_params[:amount].to_i
    unless @amount > 0 && @amount <= 100000
      app_response(body: { errors: "You can only top up amounts between Ksh 1 and Ksh 1,000,000"}, status: 400, message: 'invalid amount')
      return
    end
    @account_repo.top_up(uid: uid, amount: @amount)
    app_response(body: "You have successfully toped up Ksh #{@amount}", status: 200, message: "success" )
  end

  def withdraw
    @amount = withdraw_params[:amount].to_i
    unless @amount > 0 && @amount <= 100000
      app_response(body: { errors: "You can only withdraw amounts between Ksh 1 and Ksh 1,000,000"}, status: 400, message: 'invalid amount')
      return
    end
    if @account_repo.withdraw(uid: uid, amount: @amount) == 0
      app_response(body: "You have successfully withdrawn Ksh #{@amount}", status: 200, message: 'success')
    else
      app_response(body: { errors: "You can not withdraw beyond your balance"}, status: 400, message: 'insufficient balance')
    end
  end

  private

  def topup_params
    params.require(:account).permit(:amount)
  end

  def withdraw_params
    params.require(:account).permit(:amount)
  end

end
