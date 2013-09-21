class CreateTrackerMembers < ActiveRecord::Migration
  def change
    create_table :tracker_members do |t|
      t.integer :tracker_id, null: false
      t.string :login, null: false
      t.string :full_name, null: false
      t.string :email
      t.time :last_access
      t.timestamps
    end
  end
end
