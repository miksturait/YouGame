class TrackerInstallWorker
  @queue = :yougame_install

  def self.perform(tracker_id)
    tracker = Tracker.find(tracker_id)
    Tracker::Install::YouTrack.new(tracker)
  end
end