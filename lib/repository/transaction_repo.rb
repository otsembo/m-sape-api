# frozen_string_literal: true
require_relative 'user_repo'
class TransactionRepo

  def initialize
    @user_repo = UserRepo.new
  end
  def add_transaction(uid:, amount:, party_b:, type:, date:)
    @user_repo.find_user(uid: uid)
              .transactions
              .create(
                amount: amount,
                party_b: party_b,
                transaction_type: type,
                transfer_date: date
              )
  end

  def view_transactions(uid:, type:)
    @user_repo.find_user(uid: uid)
             .transactions.where(transaction_type: type).order(:created_at).last(5)
              .map { |t| ActiveModelSerializers::SerializableResource.new(t, serializer: TransactionSerializer) }
  end

end
