class Tracker::Broadcast::AchievementsSet < Tracker::Broadcast::Data

  def prepare
    tracker.custom_achievements.as_json(only: [:id], methods: [:name, :exp_points, :mineral_points, :message, :original_picture])
  end

end