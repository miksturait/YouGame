class CreateTrackerProjects < ActiveRecord::Migration
  def change
    create_table :tracker_projects do |t|
      t.integer :tracker_id, null: false
      t.string :name, null: false
      t.string :project_id, null: false
      t.string :description
      t.string :lead
      t.integer :lead_id
      t.timestamps
    end
  end
end
