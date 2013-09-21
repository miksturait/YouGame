class Tracker::Broadcast::AchievementsObtainsSet < Tracker::Broadcast::Data

  def prepare
    tracker.achievements_obtains.as_json(only: [:achievement_id, :member_id, :occurrences])
  end

end