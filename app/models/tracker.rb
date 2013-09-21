class Tracker < ActiveRecord::Base

  serialize :last_broadcast, JSON
  has_associated_audits

  attr_accessor :conn
  attr_accessible :admin_username, :admin_password, :username, :password, :url,
                  :issue_difficulty_field, :issue_accepted_state, :issue_in_progress_state, :issue_backlog_state,
                  :hidden_group_ids, :hidden_project_ids, :hidden_member_ids, :broadcast_required

  validates :admin_username, :admin_password, presence: true, on: :create
  validates :url, presence: true, uniqueness: true
  validate :admin_credentials_provided, on: :create

  validates :issue_difficulty_field, :issue_accepted_state, :issue_in_progress_state, :issue_backlog_state, presence: true,
            unless: proc{|o| %w(new installing).include? o.state}

  has_many :members, dependent: :destroy
  has_many :groups, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :custom_achievements, class_name: Achievement::Custom, dependent: :destroy
  has_many :achievements_obtains
  has_many :levels, dependent: :destroy
  has_many :points_obtains, dependent: :destroy
  has_many :api_points_requests, dependent: :destroy
  has_many :reports, dependent: :destroy

  has_one :current_level, class_name: Tracker::Level, conditions: ["month = ?", Date.today.beginning_of_month.to_s]

  has_many :users, through: :members

  before_validation :set_api_key, on: :create
  after_create :install
  after_update :check_current_level

  delegate :check_current_level, to: :current_level, allow_nil: true

  scope :with_user_activity, ->{
    where('last_user_activity_at > ?', 7.days.ago)
  }

  scope :should_be_updated, ->{ with_user_activity.where(state: 'idle') }

  scope :hanging, ->{
    where('updated_at > ?', 5.minutes.ago).
    where(state: 'updating')
  }

  state_machine :state, initial: :new do
    state :new
    state :installing
    state :idle
    state :updating
    state :broken_config

    event :install do
      transition [:new, :broken_config] => :installing
    end

    event :move_to_idle do
      transition [:idle, :installing, :updating] => :idle
    end

    event :make_update do
      transition idle: :updating
    end

    event :make_full_update do
      transition idle: :updating
    end

    before_transition on: :move_to_idle, do: :clear_admin_credentials
    after_transition on: :install, do: :enqueue_installation
    after_transition on: :make_update, do: :enqueue_update
    after_transition on: :make_full_update, do: :enqueue_full_update
  end

  def init_conn
    self.conn ||= YouTrackApi.new(url, admin_username || username, admin_password || password)
  end

  def make_broadcast_data
    {
      level: Tracker::Broadcast::Level.new(self).data,
      current_assignments: Tracker::Broadcast::CurrentAssignmentsSet.new(self).data,
      activities: Tracker::Broadcast::Activity.new(self).data,
      ranking: Tracker::Broadcast::Ranking.new(self).data,
      audits: Tracker::Broadcast::AuditsSet.new(self).data,
      members: Tracker::Broadcast::MembersSet.new(self).data,
      minerals: Tracker::Broadcast::Mineral.new(self).data,
      achievements: Tracker::Broadcast::AchievementsSet.new(self).data,
      achievements_obtains: Tracker::Broadcast::AchievementsObtainsSet.new(self).data
    }
  end

  def visible_members
    ids = hidden_member_ids || []
    members.where{id.not_in ids}
  end

  def mailable_members
    visible_members.joins(:user).where(user: {receive_emails: true})
  end

  def list_of_accepted_states
    states_from_string :issue_accepted_state
  end

  def list_of_in_progress_states
    states_from_string :issue_in_progress_state
  end

  def list_of_backlog_states
    states_from_string :issue_backlog_state
  end

  def generate_api_key!
    set_api_key
    save
  end

  private
  def states_from_string(state_field)
    (self[state_field] || '').split(',').map(&:strip)
  end

  def admin_credentials_provided
    begin
      init_conn
      return errors.add(:url, 'could not connect to YouTrack (wrong url or credentials)') unless conn.valid?
    rescue
      return errors.add(:url, 'could not connect to YouTrack')
    end

    begin
      conn.get_current_user
      admin_login = conn.document.children.first.attributes['login'].value

      conn.get_user_roles(id: admin_login)
      has_admin_role = conn.document.children.first.children.map{|role|role.attributes['name'].value}.include? 'Admin'

      errors.add(:admin_username, 'does not have Admin role') unless has_admin_role
    rescue
      errors.add(:admin_username, 'has not sufficient permissions') unless has_admin_role
    end
  end

  def clear_admin_credentials
    self.admin_username = nil
    self.admin_password = nil
  end

  def set_api_key
    new_api_key = SecureRandom.urlsafe_base64 nil, false
    if Tracker.find_by_api_key new_api_key
      set_api_key
    else
      self.api_key = new_api_key
    end
  end

  def enqueue_installation
    Resque.enqueue(TrackerInstallWorker, self.id)
  end

  def enqueue_update
    Resque.enqueue(TrackerUpdateWorker, self.id, false)
  end

  def enqueue_full_update
    Resque.enqueue(TrackerUpdateWorker, self.id, true)
  end

end
