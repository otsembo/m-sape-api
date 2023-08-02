class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :party_b, null: false, foreign_key: true
      t.date :transfer_date, null: false
      t.float :amount, default: 0.0, null: false
      t.integer :type, default: 0, null: false

      t.timestamps
    end
  end
end
