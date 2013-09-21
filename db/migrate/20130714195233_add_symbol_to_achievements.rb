class AddSymbolToAchievements < ActiveRecord::Migration
  def change
    add_column :achievements, :symbol, :string
    Achievement.reset_column_information
    Achievement.all.each do |achievement|
      achievement.update_attributes symbol: achievement.name.underscore
    end
  end
end
