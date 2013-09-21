class Tracker::MemberGroup < ActiveRecord::Base

  include TrackerItem

  attr_accessible :member_id, :group_id

  belongs_to :member
  belongs_to :group

  validates :member_id, :group_id, presence: true

end
