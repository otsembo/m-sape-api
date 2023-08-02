class Transaction < ApplicationRecord
  belongs_to :user
  validates :amount, { presence: true, numericality: { in: 1..100000 }}
  validates :transfer_date, { presence: true }
  enum :transaction_type, [:deposit, :withdraw, :receive, :transfer]
end
