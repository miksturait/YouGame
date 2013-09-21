class Audit < Audited::Adapters::ActiveRecord::Audit

  def get_data
    send "data_for_#{auditable_type.demodulize.underscore}"
  end

  private

  def data_for_issue
    return data_for_removed unless auditable

    subject, text = [], []
    if audited_changes.keys.include? 'assignee'
      subject << "assigned"
      text    << "has been assigned to <span class=\"important-text\">#{revision.assignee_full_name}</span>"
    end

    if audited_changes.keys.include? 'state'
      subject << "state changed"
      text    << "changed state to <span class=\"important-text\">#{revision.state}</span>"
    end

    subject = "Issue #{subject.to_sentence}"
    text    = "<a href=\"#{auditable.url}\" title=\"#{auditable.issue_id}\" target=\"_blank\"><span class=\"important-text\">#{auditable.summary}</span></a> #{text.to_sentence}"
    { member_id: revision.updater_id, subject: subject, text: text, created_at: created_at, notify: false }
  end

  def data_for_points_obtain
    return data_for_removed unless auditable

    mineral_label = auditable.tracker.levels.find_by_month(created_at.beginning_of_month).mineral_label
    case auditable.subject_type
      when 'Tracker::Issue'
        subject = I18n.t('audits.tracker_issue.subject_html', full_name: revision.member.full_name)
        text    = I18n.t('audits.tracker_issue.text_html',
                         exp: revision.exp_points,
                         mineral: revision.mineral_points,
                         mineral_label: mineral_label,
                         issue_url: auditable.subject.url,
                         issue_id: auditable.subject.issue_id,
                         task: revision.subject.summary)
      when 'Achievement'
        subject = I18n.t('audits.achievement.subject_html', full_name: revision.member.full_name)
        text    = I18n.t('audits.achievement.text_html',
                         mineral: revision.mineral_points,
                         mineral_label: mineral_label,
                         exp: revision.exp_points, achievement: revision.subject.name)
      when 'Tracker::ApiPointsRequest'
        subject = I18n.t('audits.api_points_request.subject_html', full_name: revision.member.full_name)
        text    = I18n.t('audits.api_points_request.text_html',
                         exp: revision.exp_points,
                         mineral: revision.mineral_points,
                         mineral_label: mineral_label,
                         related_url: auditable.subject.related_url,
                         related_url_present: auditable.subject.related_url.present?,
                         description: auditable.subject.for)
      else
        subject, text = ''
    end
    { member_id: revision.member_id, subject: subject, text: text, created_at: created_at, notify: true }
  end

  def data_for_removed
    return { member_id: (revision.respond_to?(:member_id) ? revision.member_id : revision.assignee_id),
             subject: "Log entry removed",
             text: "<span class=\"important-text\">This log entry is no longer valid</span>",
             created_at: created_at }
  end

end