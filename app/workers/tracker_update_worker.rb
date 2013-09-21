class TrackerUpdateWorker
  @queue = :yougame_update

  def self.perform(tracker_id, full_update)
    tracker = Tracker.find(tracker_id)
    Tracker::Update::YouTrack.new(tracker, full_update: full_update)
  end

  def self.full_update_for_active_tracker
    Tracker.with_user_activity.each{ |tracker| tracker.make_full_update }
  end

end