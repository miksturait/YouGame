class AddApiKeyToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :api_key, :string
    Tracker.reset_column_information
    Tracker.all.each{|tracker| tracker.generate_api_key!}
  end
end
