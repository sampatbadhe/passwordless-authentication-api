class RemoveLoginTokenFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :login_token
  end
end
