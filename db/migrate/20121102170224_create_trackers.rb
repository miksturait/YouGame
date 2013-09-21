class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string :url, null: false
      t.string :state, null: false
      t.string :username
      t.string :password
      t.string :admin_username
      t.string :admin_password
      t.string :issue_points_field
      t.string :issue_accepted_state
      t.string :role_name
      t.datetime :last_sync_at
      t.datetime :last_user_activity_at
      t.timestamps
    end
  end
end
