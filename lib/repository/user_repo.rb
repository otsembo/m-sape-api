# frozen_string_literal: true

class UserRepo

  def login(email:, password:)
    user = User.find_by(email: email)
    user ? user.id : nil
  end

  def create_account(email:, password:, phone:)
    User.create(email: email, password: password, phone: phone, last_login: Time.now)
  end

  def delete_user(uid:)
    User.find(uid).delete
  end

  def search_user(email:)
    User.find_by(email: email)
  end
end