class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :tracker_member_id, :receive_emails

  belongs_to :tracker_member, class_name: "Tracker::Member", foreign_key: :tracker_member_id
  has_one :tracker, through: :tracker_member

  delegate :installing?, to: :tracker, prefix: :tracker, allow_nil: true

  def update_activity_stamp
    if tracker
      tracker.last_user_activity_at = DateTime.now
      tracker.save
    end
  end

  def assign_tracker_member
    member = Tracker::Member.find_by_email email
    update_column(:tracker_member_id, member.id) if member
  end

  def is_project_leader?
    tracker and tracker.projects.where(lead_id: tracker_member_id).present?
  end

end
