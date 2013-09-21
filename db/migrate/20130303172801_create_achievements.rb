class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.string :type, null: false
      t.integer :tracker_id
      t.string :name
      t.string :message
      t.integer :points, default: 0
      t.timestamps
    end
  end
end
