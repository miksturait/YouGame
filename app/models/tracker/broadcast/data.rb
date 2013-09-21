class Tracker::Broadcast::Data

  attr_accessor :tracker, :data

  def initialize tracker
    self.tracker = tracker.reload
    self.data = prepare
  end
end