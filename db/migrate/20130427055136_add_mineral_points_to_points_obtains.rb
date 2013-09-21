class AddMineralPointsToPointsObtains < ActiveRecord::Migration
  def change
    add_column :tracker_points_obtains, :mineral_points, :integer, default: 0
  end
end
