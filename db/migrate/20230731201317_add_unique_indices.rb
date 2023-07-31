class AddUniqueIndices < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email, unique: true, name: 'unique_email_index'
    add_index :users, :phone, unique: true, name: 'unique_phone'
  end
end
