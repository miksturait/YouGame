class AddHiddenFieldsToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :hidden_project_ids, :string_array
    add_column :trackers, :hidden_member_ids, :string_array
    add_column :trackers, :hidden_group_ids, :string_array
  end
end
