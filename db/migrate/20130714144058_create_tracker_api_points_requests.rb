class CreateTrackerApiPointsRequests < ActiveRecord::Migration
  def change
    create_table :tracker_api_points_requests do |t|
      t.integer :tracker_id, null: false
      t.string :email, null: false
      t.string :for
      t.integer :exp_points, null: false
      t.integer :mineral_points, null: false
      t.string :related_url
      t.string :achievement_symbol
      t.timestamps
    end
  end
end
