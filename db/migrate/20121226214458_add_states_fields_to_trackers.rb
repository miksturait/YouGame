class AddStatesFieldsToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :issue_in_progress_state, :string
    add_column :trackers, :issue_backlog_state, :string
  end
end
