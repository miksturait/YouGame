class Tracker::ApiPointsRequest < ActiveRecord::Base

  attr_accessible :email, :for, :exp_points, :mineral_points, :related_url, :achievement_symbol

  belongs_to :tracker

  belongs_to :member, foreign_key: :email, primary_key: :email
  belongs_to :achievement, foreign_key: :achievement_symbol, primary_key: :symbol

  validate :member_existence
  validate :achievement_existence, if: proc {|o|o.achievement_symbol.present?}

  validates_presence_of :email, :tracker_id, :exp_points, :mineral_points
  validates_presence_of :for, unless: proc {|o|o.achievement_symbol.present?}

  after_create :spawn_points

  private
  def member_existence
    errors.add(:email, 'does not match any member') unless tracker.members.find_by_id(member)
  end

  def achievement_existence
    return errors.add(:achievement_symbol, 'does not match any achievement') unless tracker.custom_achievements.find_by_id(achievement)
    self.exp_points = achievement.exp_points
    self.mineral_points = achievement.mineral_points
  end

  def spawn_points
    point_obtain = tracker.points_obtains.create(subject: self)
    errors.add(:base, point_obtain.errors.full_messages.to_sentence) unless point_obtain.valid?
  end

end
