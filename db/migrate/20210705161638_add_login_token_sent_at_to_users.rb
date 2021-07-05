class AddLoginTokenSentAtToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :login_token_sent_at, :datetime
  end
end
