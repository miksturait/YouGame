class CreateTrackerReports < ActiveRecord::Migration
  def change
    create_table :tracker_reports do |t|
      t.integer :tracker_id, null: false
      t.text :message, null: false, default: ''
      t.integer :project_id, null: false
      t.integer :creator_id, null: false
      t.string :report_date, null: false
      t.timestamps
    end
  end
end
