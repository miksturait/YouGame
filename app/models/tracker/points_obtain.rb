class Tracker::PointsObtain < ActiveRecord::Base

  STAMINA_EXHAUSTED_HOURS     = 8.0 # hours
  STAMINA_CRITICAL_PERCENT    = 30  # percent
  STAMINA_COSTS               = { 'Hard' => 4.5, 'Medium' => 3.0, 'Easy' => 1.8, 'No Effort' => 0.8 }

  ISSUE_EXP_POINTS            = 150.0
  ISSUE_MINERAL_POINTS        = 300.0
  ISSUE_DIFFICULTY_MODIFIERS  = { 'Hard' => 1.8, 'Medium' => 1.4, 'Easy' => 1.0 }
  ISSUE_TYPE_MODIFIERS        = {'Bug' => 0.8, 'Feature' => 1.3 }
  ISSUE_RANDOM_OFFSET         = 0.18
  ISSUE_HELP_OFFSET           = 0.35

  audited associated_with: :tracker, on: [:create]

  attr_accessible :tracker_id, :member_id, :subject, :subject_id, :subject_type, :description

  belongs_to :subject, polymorphic: true
  belongs_to :member, class_name: Tracker::Member
  belongs_to :tracker

  delegate :full_name, to: :member, allow_nil: true, prefix: :member
  delegate :calculate_stamina_recovery, to: :member

  before_validation :calculate_points, on: :create
  after_save :calculate_stamina_recovery, if: proc{|o|o.subject_type == 'Tracker::Issue'}

  private
  def calculate_points
    type = subject_type.underscore.gsub('/', '_')
    respond_to?("set_points_for_#{type}", true) ? send("set_points_for_#{type}") : set_points_for_unknown
  end

  def set_points_for_unknown
    self.exp_points     = 0
    self.mineral_points = 0
  end

  def set_points_for_tracker_issue
    stamina = member.current_stamina

    #exp_points
    points = ISSUE_EXP_POINTS
    points *= subject.reopen_factor
    points *= (ISSUE_DIFFICULTY_MODIFIERS[subject.difficulty] || 0.5)
    points *= (ISSUE_TYPE_MODIFIERS[subject.type] || 1.0)
    points *= 1 + ((rand(2*ISSUE_RANDOM_OFFSET*100)-ISSUE_RANDOM_OFFSET*100).to_f / 100)
    points *= member.current_stamina / 100.0 if stamina < STAMINA_CRITICAL_PERCENT
    self.exp_points = points.to_i

    #mineral_points
    diff = tracker.current_level.time_progress - tracker.current_level.progress
    help_modifier = ((diff > -10 and diff < 10) ? 1.0 : ((diff < -10) ? 1-ISSUE_HELP_OFFSET : 1+ISSUE_HELP_OFFSET))
    points = ISSUE_MINERAL_POINTS
    points *= subject.reopen_factor
    points *= (ISSUE_DIFFICULTY_MODIFIERS[subject.difficulty] || 0.5)
    points *= help_modifier
    points *= 1 + ((rand(2*ISSUE_RANDOM_OFFSET*100)-ISSUE_RANDOM_OFFSET*100).to_f / 100)
    points *= member.current_stamina / 100.0 if stamina < STAMINA_CRITICAL_PERCENT
    self.mineral_points = points.to_i
  end

  def set_points_for_achievement
    self.exp_points     = subject.exp_points
    self.mineral_points = subject.mineral_points
  end

  def set_points_for_tracker_api_points_request
    self.exp_points     = subject.exp_points
    self.mineral_points = subject.mineral_points
    self.member_id      = subject.member.id
    self.subject        = subject.achievement if subject.achievement
  end

end
