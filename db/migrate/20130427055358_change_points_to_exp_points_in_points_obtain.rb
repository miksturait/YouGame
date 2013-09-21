class ChangePointsToExpPointsInPointsObtain < ActiveRecord::Migration
  def up
    rename_column :tracker_points_obtains, :points, :exp_points
  end

  def down
    rename_column :tracker_points_obtains, :exp_points, :points
  end
end
