class AddReceiveEmailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_emails, :boolean, null: false, default: true
  end
end
