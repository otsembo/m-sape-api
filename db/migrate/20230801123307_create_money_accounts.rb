class CreateMoneyAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :money_accounts do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.float :balance, default: 0.0, null: false

      t.timestamps
    end
  end
end
