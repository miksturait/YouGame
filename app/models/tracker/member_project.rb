class Tracker::MemberProject < ActiveRecord::Base

  include TrackerItem

  attr_accessible :member_id, :project_id

  belongs_to :member
  belongs_to :project

  validates :member_id, :project_id, presence: true
end
