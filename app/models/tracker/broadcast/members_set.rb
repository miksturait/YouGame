class Tracker::Broadcast::MembersSet < Tracker::Broadcast::Data

  def prepare
    tracker.members.as_json(only: [:id, :full_name, :stamina_recovered_at],
                            methods: [:avatar_url, :achievement_obtains, :exp_points, :current_level_minerals, :total_minerals_points])
  end

end