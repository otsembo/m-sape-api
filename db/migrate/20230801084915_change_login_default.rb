class ChangeLoginDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :last_login,  from: nil, to: 'CURRENT_TIMESTAMP'
  end
end
