class AddBroadcastRequiredToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :broadcast_required, :boolean, default: false
  end
end
