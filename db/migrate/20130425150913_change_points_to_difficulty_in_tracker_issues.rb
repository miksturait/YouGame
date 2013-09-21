class ChangePointsToDifficultyInTrackerIssues < ActiveRecord::Migration
  def up
    remove_column :tracker_issues, :points
    add_column :tracker_issues, :difficulty, :string
  end

  def down
    remove_column :tracker_issues, :difficulty
    add_column :tracker_issues, :points, :string
  end
end
