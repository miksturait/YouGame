class CreateTrackerMemberProjects < ActiveRecord::Migration
  def change
    create_table :tracker_member_projects do |t|
      t.integer :project_id, null: false
      t.integer :member_id, null: false
      t.timestamps
    end
  end
end
