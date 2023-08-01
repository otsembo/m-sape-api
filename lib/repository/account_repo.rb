# frozen_string_literal: true

class AccountRepo

  def create(user)
    MoneyAccount.create(user_id: user.id)
  end

  def find_by_user(user)
    MoneyAccount.find_by(user_id: user.id)
  end

end
