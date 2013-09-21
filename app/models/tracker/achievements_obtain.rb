class Tracker::AchievementsObtain < ActiveRecord::Base

  self.table_name = 'tracker_achievements_obtains'

  belongs_to :achievement
  belongs_to :member, class_name: Tracker::Member
  belongs_to :tracker
end