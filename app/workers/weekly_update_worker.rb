class WeeklyUpdateWorker

  def initialize(tracker, member)
    @tracker = tracker
    @member  = member
    @date    = 1.week.ago
  end

  def self.perform
    Tracker.with_user_activity.each do |tracker|
      tracker.mailable_members.each do |member|
        self.new(tracker, member).deliver
      end
    end
  end

  def title
    I18n.t('mails.week_update.title', week_number: date.strftime("%U").to_i)
  end

  def subtitle
    I18n.t('mails.week_update.subtitle', from: date.beginning_of_week.to_date.to_s(:short), to: date.end_of_week.to_date.to_s(:short))
  end

  def progress_percent
      "#{tracker.current_level.progress}%"
  end

  def progress_label
    if progress_in_time > 25
      I18n.t('mails.week_update.progress_labels.great')
    elsif progress_in_time > 15
      I18n.t('mails.week_update.progress_labels.right_direction')
    elsif progress_in_time > 5
      I18n.t('mails.week_update.progress_labels.on_track')
    elsif progress_in_time > -5
      I18n.t('mails.week_update.progress_labels.perform_better')
    elsif progress_in_time > -15
      I18n.t('mails.week_update.progress_labels.not_enough_minerals')
    else
      I18n.t('mails.week_update.progress_labels.mission_in_danger')
    end
  end

  def progress_css_class
    if progress_in_time > 15
      "time-good"
    elsif progress_in_time > -5
      "time-ok"
    else
      "time-alert"
    end
  end

  def member_avatar
    member.avatar_url + "?s=#{150}"
  end

  def member_minerals_last_week
    member.minerals_in_period(date.beginning_of_week, date.end_of_week)
  end

  def member_place_in_ranking
    ranking.index(member) + 1
  end

  def leader_avatar
    leader.avatar_url + "?s=#{150}"
  end

  def leader_minerals_last_week
    leader.minerals_in_period(date.beginning_of_week, date.end_of_week)
  end

  def leader_place_in_ranking
    1
  end

  def member
    @member
  end

  def reports
    @reports ||= tracker.reports.where(report_date: @date.beginning_of_week.to_date.to_s).where("message != '' and message is not null")
  end

  def leader
    ranking.first
  end

  def email
    member.user.email
  end

  def deliver
    AppMailer.weekly_update(self).deliver
  end

  private
  def date
    @date
  end

  def tracker
    @tracker
  end

  def progress_in_time
    @progress_in_time ||= (tracker.current_level.progress - tracker.current_level.time_progress)
  end

  def ranking
    week_begin = date.beginning_of_week
    week_end   = date.end_of_week
    @ranking ||= tracker.visible_members.sort do |a,b|
      a.minerals_in_period(week_begin, week_end) <=> b.minerals_in_period(week_begin, week_end)
    end.reverse
  end

end