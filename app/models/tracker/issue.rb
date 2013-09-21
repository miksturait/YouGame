class Tracker::Issue < ActiveRecord::Base

  audited associated_with: :tracker, only: [:assignee_id, :assignee, :state]

  self.inheritance_column = nil

  include TrackerItem

  attr_accessible :project_short_name, :number_in_project, :summary, :description, :created, :updated, :updater_name,
                  :updater_full_name, :reporter_name, :reporter_full_name, :comments_count, :votes, :priority,
                  :type, :state, :assignee, :subsystem, :difficulty, :issue_id, :resolved

  belongs_to :tracker

  belongs_to :project
  belongs_to :assignee_member, class_name: Tracker::Member, foreign_key: :assignee_id
  belongs_to :reporter, class_name: Tracker::Member, foreign_key: :reporter_id
  belongs_to :updater, class_name: Tracker::Member, foreign_key: :updater_id

  has_one :points_obtain, as: :subject, dependent: :destroy

  before_validation :set_project, :set_updater, :set_reporter, :set_assignee

  after_save :spawn_points, if: :should_create_points?
  after_save :remove_points, if: :should_remove_points?

  validates :tracker_id, :project_id, :updater_id, :reporter_id, :issue_id, :summary, presence: true
  validates :assignee_id, if: :assignee, presence: true

  delegate :full_name, to: :assignee_member, allow_nil: true, prefix: :assignee

  def url
    tracker.url + '/issue/' + issue_id
  end

  private
  def set_project
    if project_short_name_changed?
      self.project  = tracker.projects.find_by_project_id(project_short_name)
    end
  end

  def set_updater
    if updater_name_changed?
      self.updater  = tracker.members.find_by_login(updater_name)
    end
  end

  def set_reporter
    if reporter_name_changed?
      self.reporter = tracker.members.find_by_login(reporter_name)
    end
  end

  def set_assignee
    if assignee_changed?
      self.assignee_member = tracker.members.find_by_login(assignee)
    end
  end

  def state_changed_to_verified?
    tracker.list_of_accepted_states.include?(changes[:state].try(:last))
  end

  def state_changed_from_verified?
    changed_state = changes[:state].try(:last)
    changed_state.present? and !tracker.list_of_accepted_states.include?(changed_state)
  end

  def should_create_points?
    state_changed_to_verified? and points_obtain.nil? and assignee_member.present?
  end

  def should_remove_points?
    state_changed_from_verified? and points_obtain.present?
  end

  def spawn_points
    create_points_obtain(tracker_id: tracker_id, member_id: assignee_id)
  end

  def remove_points
    update_column :reopen_factor, (reopen_factor * 0.7)
    points_obtain.destroy
  end

end
