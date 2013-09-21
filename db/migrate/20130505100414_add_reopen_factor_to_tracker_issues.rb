class AddReopenFactorToTrackerIssues < ActiveRecord::Migration
  def change
    add_column :tracker_issues, :reopen_factor, :float, default: 1.0, null: false
  end
end
