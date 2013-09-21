class Tracker::Broadcast::CurrentAssignmentsSet < Tracker::Broadcast::Data

  def prepare
    tracker.members.map do |member|
      result = {member_id: member.id}
      [:in_progress, :backlog, :accepted].each_with_object(result) do |state, hash|
        hash[state] = member.assigned_issues.
                        where(state: tracker.send("list_of_#{state}_states")).limit(3).
                        order('updated_at DESC').
                        as_json(only: [:summary, :difficulty, :issue_id])
      end
    end
  end

end