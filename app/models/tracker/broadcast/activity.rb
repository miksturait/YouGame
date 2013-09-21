class Tracker::Broadcast::Activity < Tracker::Broadcast::Data

  def prepare
      tracker.associated_audits.reorder('created_at desc').limit(40).map do |audit|
        audit = audit.becomes(Audit)
        audit.get_data
      end
  end

end