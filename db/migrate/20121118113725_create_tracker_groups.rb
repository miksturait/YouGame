class CreateTrackerGroups < ActiveRecord::Migration
  def change
    create_table :tracker_groups do |t|
      t.integer :tracker_id, null: false
      t.string :name, null: false
      t.string :description
      t.timestamps
    end
  end
end
