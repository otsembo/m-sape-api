class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :phone, null: false, unique: true
      t.string :email, null: false, unique: true
      t.timestamp :last_login, null: false

      t.timestamps
    end
  end
end
