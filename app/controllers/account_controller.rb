require_relative '../../lib/repository/account_repo'
require_relative '../../lib/repository/user_repo'
require_relative '../../lib/repository/transaction_repo'

class AccountController < ApplicationController
  before_action :auth_request

  def initialize
    @amount = 0.0
    @account_repo = AccountRepo.new
    @user_repo = UserRepo.new
    @transaction_repo = TransactionRepo.new
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

  def transfer
    @amount = transfer_params[:amount].to_i
    unless @amount > 0 && @amount <= 100000
      app_response(body: { errors: "You can only transfer amounts between Ksh 1 and Ksh 1,000,000"}, status: 400, message: 'invalid amount')
      return
    end
    user = @user_repo.search_user(email: params[:user_mail])
    if user
      unless user.id != uid
        app_response(body: { errors: "You can not transfer to yourself"}, status: 400, message: 'invalid user')
        return
      end
      if @account_repo.transfer(sender: uid, receiver: user.id, amount: @amount) == 0
        app_response(body: "You have successfully transfered Ksh #{@amount} to #{user.email}", status: 200, message: "success")
      else
        app_response(body: { errors: "You can not transfer beyond your balance"}, status: 400, message: 'insufficient balance')
      end
    else
      app_response(body: { errors: "User does not exist"}, status: 400, message: 'invalid user')
    end
  end

  def transactions
    options = %w[transfer deposit withdraw receive]
    type = params[:type].to_s.downcase
    unless options.include?(type)
      app_response(body: { errors: "Invalid transaction type"}, status: 400, message: 'invalid transaction type')
      return
    end
    @transactions = @transaction_repo.view_transactions(uid: uid, type: type)
    app_response(body: @transactions, status: 200, message: 'fetched transaction')
  end


  private

  def topup_params
    params.require(:account).permit(:amount)
  end

  def withdraw_params
    params.require(:account).permit(:amount)
  end

  def transfer_params
    params.require(:account).permit(:amount, :user_mail)
  end

end
