class AddMineralPointsToAchievements < ActiveRecord::Migration
  def change
    rename_column :achievements, :points, :exp_points
    add_column :achievements, :mineral_points, :integer, default: 0
  end
end
