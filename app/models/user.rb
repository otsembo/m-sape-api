class User < ApplicationRecord
  has_secure_password
  validates :email, { presence: true, length: { minimum: 5 }, uniqueness: true }
  validates :phone, { presence: true, length: { minimum: 9}, uniqueness: true }
  validates :password, { presence: true, length: { minimum: 6 } }
  validate  :email_validity_check

  has_one :money_account
  has_many :transactions

  private

  def email_validity_check
    unless email.match /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/
      errors.add(:email, "This does not appear to be a valid email")
    end
  end

end
