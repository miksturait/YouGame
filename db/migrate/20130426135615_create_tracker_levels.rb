class CreateTrackerLevels < ActiveRecord::Migration
  def change
    create_table :tracker_levels do |t|
      t.string :planet_name
      t.string :brood_name
      t.string :mineral_name
      t.date :month
      t.integer :tracker_id
      t.integer :target
      t.datetime :completed_at

      t.timestamps
    end
  end
end
