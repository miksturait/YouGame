class Tracker::Broadcast::Level < Tracker::Broadcast::Data

  def prepare
    level = tracker.current_level || Tracker::Level.generate_for(tracker)
    level.as_json(only: ['target'], methods: [:collected, :planet_label, :planet_description, :planet_image_path, :brood_label,
                            :brood_description, :brood_image_path, :mineral_label, :mineral_description, :mineral_small_image_path,
                            :mineral_image_path, :tracker_url])
  end

end