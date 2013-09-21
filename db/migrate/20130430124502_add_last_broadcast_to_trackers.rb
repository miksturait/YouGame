class AddLastBroadcastToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :last_broadcast, :text, default: '{}'
  end
end
