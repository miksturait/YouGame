class Tracker::Update::YouTrack < Tracker::Adapters::YouTrack

  protected
  def process
    tracker.current_level || Tracker::Level.generate_for(tracker)
    tracker.last_sync_at ||= DateTime.now
    if options[:full_update]
      update_members
      update_groups
      update_groups_memberships
      update_projects
      update_project_memberships
      clear_nonexisting_tasks
      tracker.last_full_sync_at = DateTime.now
      tracker.move_to_idle
    else
      if update_issues
        broadcast_changes if tracker.broadcast_required
        tracker.last_sync_at = DateTime.now
        tracker.move_to_idle
      else
        self.class.new(tracker.reload, full_update: true)
      end
    end
  end

  def update_members
    results_per_page = 10
    there_is_more    = true
    existing         = tracker.members.dup
    current_start    = 0

    while there_is_more
      conn.get_users(start: current_start)
      fetched_data = Tracker::Member.attrs_from_xml(conn.document)
      fetched_data.each do |attrs|
        if attrs['login'].present?
          member = tracker.members.find_or_initialize_by_login(attrs['login'])
          existing.reject!{|m|m.id == member.id}

          conn.get_user(id: attrs['login'])
          attrs = Tracker::Member.attrs_from_xml(conn.document).first

          member.skip_exists_check = true
          member.update_attributes(attrs)
        else
          there_is_more = false
        end
      end
      current_start += results_per_page
    end
  end

  def update_groups
    existing = tracker.groups.dup
    conn.get_groups
    Tracker::Group.attrs_from_xml(conn.document).each do |attrs|
      group = tracker.groups.find_or_initialize_by_name(attrs['name'])
      existing.reject!{|g|g.id == group.id}

      conn.get_group(id: attrs['name'])
      attrs = Tracker::Group.attrs_from_xml(conn.document).first
      group.update_attributes(attrs)
    end
    existing.map(&:destroy)
  end

  def update_groups_memberships
    tracker.members.each do |member|
      conn.get_user_groups(id: member.login)
      existing = tracker.groups.dup
      Tracker::Group.attrs_from_xml(conn.document).each do |attrs|
        group = tracker.groups.find_by_name(attrs['name'])
        if group.try(:id)
          existing.reject!{|g|g.id == group.id}
          member.member_groups.create(group_id: group.id) unless member.groups.include?(group)
        end
      end
      member.member_groups.where(group_id: existing.map(&:id)).map(&:destroy)
    end
  end

  def update_projects
    existing = tracker.projects.dup
    conn.get_projects
    Tracker::Project.attrs_from_xml(conn.document).each do |attrs|
      project = tracker.projects.find_or_initialize_by_project_id(attrs['project_id'])
      existing.reject!{|p|p.id == project.id}

      conn.get_project(id: attrs['project_id'])
      attrs = Tracker::Project.attrs_from_xml(conn.document).first
      project.update_attributes(attrs)
    end
    existing.map(&:destroy)
  end

  def update_project_memberships
    tracker.projects.each do |project|
      conn.get_project_assignees(id: project.project_id)
      existing = tracker.members.dup
      Tracker::Member.attrs_from_xml(conn.document.children.first).each do |attrs|
        member = tracker.members.find_by_login(attrs['login'])
        if member.try(:id)
          existing.reject!{|m|m.id == member.id}
          member.member_projects.create(project_id: project.id) unless member.projects.include?(project)
        end
      end
      project.member_projects.where(member_id: existing.map(&:id)).map(&:destroy)
    end
  end

  def update_issues
    dates_to_update = (tracker.last_sync_at.to_date..Date.today+1.day).map(&:to_s).join(',')
    conn.get_issues(max:9999, filter: "updated:#{dates_to_update}")
    Tracker::Issue.attrs_from_xml(conn.document).each do |attrs|
      if attrs['issue_id']
        issue = tracker.issues.find_or_initialize_by_issue_id(attrs['issue_id'])
        attrs['difficulty'] ||= nil
        attrs['assignee']   ||= nil
        return false unless issue.update_attributes(attrs)
        tracker.broadcast_required = true if issue.previous_changes.present?
      end
    end
    true
  end

  def clear_nonexisting_tasks
    Tracker::Broadcast::CurrentAssignmentsSet.new(tracker).data.each do |hash|
      [:in_progress, :backlog, :accepted].each do |type|
        hash[type].each do |issue_hash|
          tracker.issues.find_by_issue_id(issue_hash['issue_id']).destroy unless conn.get_issue(id: issue_hash['issue_id'])
        end
      end
    end
  end

  def broadcast_changes
    tracker.last_broadcast = tracker.make_broadcast_data.as_json
    tracker.save
    Pusher["updates_#{tracker.id}"].trigger('make_update', 'true')
    tracker.broadcast_required = false
  end
end