class CreateTrackerIssues < ActiveRecord::Migration
  def change
    create_table :tracker_issues do |t|
      t.integer :tracker_id, null: false
      t.integer :project_id, null: false
      t.integer :updater_id, null: false
      t.integer :reporter_id, null: false
      t.integer :assignee_id
      t.string :issue_id, null: false
      t.string :summary, null: false
      t.string :project_short_name
      t.string :number_in_project
      t.text :description
      t.string :created
      t.string :updated
      t.string :updater_name
      t.string :updater_full_name
      t.string :resolved
      t.string :reporter_name
      t.string :reporter_full_name
      t.string :points
      t.string :state
      t.string :assignee
      t.string :type
      t.string :priority
      t.timestamps
    end
  end
end
