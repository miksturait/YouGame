class Tracker::Group < ActiveRecord::Base

  include TrackerItem

  belongs_to :tracker

  has_many :member_groups, dependent: :destroy
  has_many :members, through: :member_groups

  attr_accessible :tracker_id, :name, :description

  validates :tracker_id, :name, presence: true
end
