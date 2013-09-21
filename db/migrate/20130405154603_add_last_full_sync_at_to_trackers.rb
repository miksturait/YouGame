class AddLastFullSyncAtToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :last_full_sync_at, :datetime
  end
end
