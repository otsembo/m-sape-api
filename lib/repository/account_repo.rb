# frozen_string_literal: true
require_relative 'user_repo'
require_relative 'transaction_repo'
class AccountRepo

  def initialize
    @user_repo = UserRepo.new
    @transaction_repo = TransactionRepo.new
  end

  def create(user)
    MoneyAccount.create(user_id: user.id)
  end

  def find_by_user(user)
    MoneyAccount.find_by(user_id: user.id)
  end

  def top_up(uid:, amount:)
    account = @user_repo.find_user(uid: uid).money_account
    account.update(balance: account.balance + amount)
    account.save
    @transaction_repo.add_transaction(
      uid: uid,
      amount: amount,
      type: 'deposit',
      date: Time.now,
      party_b: uid
    )
  end

  def withdraw(uid:, amount:)
    account = @user_repo.find_user(uid: uid).money_account
    unless  account.balance < amount
      account.update(balance: account.balance - amount)
      account.save
      @transaction_repo.add_transaction(
        uid: uid,
        amount: amount,
        type: 'withdraw',
        date: Time.now,
        party_b: uid
      )
      return 0
    end
    -1
  end

  def transfer(sender:, receiver:, amount:)
    sender_account = @user_repo.find_user(uid: sender).money_account
    receiver_account = @user_repo.find_user(uid: receiver).money_account
    unless  sender_account.balance < amount
      sender_account.update(balance: sender_account.balance - amount)
      receiver_account.update(balance: receiver_account.balance + amount)
      sender_account.save
      receiver_account.save
      @transaction_repo.add_transaction(
        uid: sender,
        amount: amount,
        type: 'transfer',
        date: Time.now,
        party_b: receiver
      )
      @transaction_repo.add_transaction(
        uid: receiver,
        amount: amount,
        type: 'receive',
        date: Time.now,
        party_b: sender
      )
      return 0
    end
    -1
  end


  private
  def find_by_id(id)
    MoneyAccount.find(id)
  end

end
