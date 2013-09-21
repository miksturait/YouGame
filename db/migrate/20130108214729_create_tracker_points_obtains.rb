class CreateTrackerPointsObtains < ActiveRecord::Migration
  def change
    create_table :tracker_points_obtains do |t|
      t.integer :member_id, null: false
      t.integer :tracker_id, null: false
      t.integer :points, null: false, default: 0
      t.integer :subject_id
      t.string :subject_type
      t.string :description
      t.timestamps
    end
  end
end
