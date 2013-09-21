class Tracker::Broadcast::AuditsSet < Tracker::Broadcast::Data

  def prepare
    tracker.associated_audits.reorder('created_at desc').where('created_at > ?', tracker.last_sync_at).map do |audit|
      audit = audit.becomes(Audit)
      audit.get_data
    end
  end

end