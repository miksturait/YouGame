class ChangeIssuePointsFieldToIssueDifficultyFieldInTracker < ActiveRecord::Migration
  def up
    remove_column :trackers, :issue_points_field
    add_column :trackers, :issue_difficulty_field, :string
    Tracker.reset_column_information
    say_with_time 'Updating issue_difficulty_field fields' do
      Tracker.update_all issue_difficulty_field: 'Difficulty'
    end
  end

  def down
    remove_column :trackers, :issue_difficulty_field, :string
    add_column :trackers, :issue_points_field
    Tracker.reset_column_information
    say_with_time 'Updating issue_points_field fields' do
      Tracker.update_all issue_points_field: 'Points'
    end
  end
end
