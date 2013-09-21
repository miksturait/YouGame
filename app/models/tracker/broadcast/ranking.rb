class Tracker::Broadcast::Ranking < Tracker::Broadcast::Data

  def prepare
    tracker.members.map do |member|
      result = {member_id: member.id}
      {today: Date.today, week: Date.today.beginning_of_week, month: Date.today.beginning_of_month}.each do |key, date|
        result[key] = member.points_obtains.where('created_at > ?', date).sum(:exp_points)
      end
      result
    end
  end

end