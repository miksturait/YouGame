class Tracker::Member < ActiveRecord::Base

  include TrackerItem

  default_scope order('full_name ASC')

  belongs_to :tracker
  has_one :user, class_name: User, foreign_key: :tracker_member_id

  has_many :assigned_issues, class_name: "Tracker::Issue", foreign_key: :assignee_id
  has_many :reported_issues, class_name: "Tracker::Issue", foreign_key: :reporter_id
  has_many :updated_issues, class_name: "Tracker::Issue", foreign_key: :updater_id

  has_many :points_obtains

  has_many :member_groups, dependent: :destroy
  has_many :groups, through: :member_groups

  has_many :member_projects, dependent: :destroy
  has_many :projects, through: :member_projects

  attr_accessor :password, :tracker_url, :skip_exists_check
  attr_accessible :login, :full_name, :email, :last_access, :password, :tracker_url, :tracker_attributes,
                  :skip_exists_check

  accepts_nested_attributes_for :tracker

  before_validation :set_tracker, :set_full_name

  validate :member_exists_on_tracker, unless: proc{|o|o.user.present? or o.skip_exists_check}
  validates :tracker, presence: true
  validate :admin_credentials_provided
  validates :login, uniqueness: {scope: :tracker_id}

  def accessible_projects
    (admin? ? tracker.projects : projects).where('tracker_projects.id not in (?)', (tracker.hidden_project_ids||[0]).map(&:to_i))
  end

  def accessible_groups
    (admin? ? tracker.groups : groups).where('tracker_groups.id not in (?)', (tracker.hidden_group_ids||[0]).map(&:to_i))
  end

  def avatar_url
    hash = Digest::MD5.hexdigest((email || '').downcase)
    "http://www.gravatar.com/avatar/#{hash}"
  end

  def achievement_obtains
    points_obtains.where(subject_type: 'Achievement')
  end

  def to_s
    full_name
  end

  def exp_points
    points_obtains.sum(:exp_points)
  end

  def current_level_minerals
    tracker.current_level.points_obtains.where(member_id: self.id).sum(:mineral_points)
  end

  def minerals_in_period(from, to)
    points_obtains.where("created_at > ? and created_at < ?", from, to).sum(:mineral_points)
  end

  def total_minerals_points
    points_obtains.
        select("tracker_levels.mineral_name, sum(tracker_points_obtains.mineral_points) as total_mineral_points").
        joins("left join tracker_levels on tracker_levels.tracker_id = tracker_points_obtains.tracker_id AND tracker_levels.month = (tracker_points_obtains.created_at::date - extract(day from tracker_points_obtains.created_at::date)::int+1)").
        group("tracker_levels.mineral_name").
        order("total_mineral_points DESC").map do |obj|
      [obj.mineral_name, obj.total_mineral_points.to_i]
    end
  end

  def calculate_stamina_recovery
    now              = Time.now.utc
    costs            = Tracker::PointsObtain::STAMINA_COSTS
    hours_to_recover = points_obtains.
      select('tracker_issues.difficulty, tracker_points_obtains.created_at').
      joins("left join tracker_issues on tracker_points_obtains.subject_id = tracker_issues.id").
      where(subject_type: 'Tracker::Issue').
      where("tracker_points_obtains.created_at > ?", (now - costs['Hard'].hours).to_s(:db)).sum do |entry|
        cost = costs[entry.difficulty] || costs['No Effort']
        diff = ((entry.created_at + cost.hours).to_time - now) / 1.hour
        [0.0, diff].max
    end
    update_column :stamina_recovered_at, (now + [Tracker::PointsObtain::STAMINA_EXHAUSTED_HOURS.hours, hours_to_recover.hours].min)
  end

  def current_stamina
    now = Time.now.utc
    [0, (100 - (100 * (((stamina_recovered_at || now)- now) / 1.hour) / Tracker::PointsObtain::STAMINA_EXHAUSTED_HOURS).round)].max
  end

  private
  def set_full_name
    self.full_name = login if full_name.blank?
  end

  def set_tracker
    unless tracker_id
      self.tracker = Tracker.new(
          admin_username: login,
          admin_password: password,
          url: tracker_url
      )
      self.admin = true
    end
  end

  def member_exists_on_tracker
    begin
      conn = YouTrackApi.new(tracker_url, login, password)
      return errors.add(:tracker_url, 'could not connect to YouTrack (wrong url or credentials)') unless conn.valid?

      conn.get_current_user
      attrs = Tracker::Member.attrs_from_xml(conn.document).first
      self.attributes = attrs
    rescue
      return errors.add(:tracker_url, 'could not connect to YouTrack')
    end
  end

  def admin_credentials_provided
    tracker_error = self.tracker.errors[:admin_username].try :first
    errors.add(:login, tracker_error) if tracker_error
  end

end
