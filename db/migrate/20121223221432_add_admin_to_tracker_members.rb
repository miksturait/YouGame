class AddAdminToTrackerMembers < ActiveRecord::Migration
  def change
    add_column :tracker_members, :admin, :boolean, default: false, null: false
  end
end
