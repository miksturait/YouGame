class CreateTrackerMemberGroups < ActiveRecord::Migration
  def change
    create_table :tracker_member_groups do |t|
      t.integer :group_id, null: false
      t.integer :member_id, null: false
      t.timestamps
    end
  end
end
