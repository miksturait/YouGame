class Tracker::Project < ActiveRecord::Base

  include TrackerItem

  attr_accessible :name, :lead, :project_id, :description

  belongs_to :tracker

  has_many :issues
  belongs_to :lead_member, class_name: Tracker::Member, foreign_key: :lead_id

  has_many :member_projects, dependent: :destroy
  has_many :members, through: :member_projects

  has_many :reports
  has_one :current_report, class_name: Tracker::Report, conditions: ["report_date = ?", Date.today.beginning_of_week.to_s]

  before_validation :set_lead

  validates :tracker_id, :project_id, :lead_id, :name, presence: true

  private
  def set_lead
    if lead_changed?
      self.lead_member  = tracker.members.find_by_login(lead)
    end
  end
end
