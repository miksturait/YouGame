class Achievement < ActiveRecord::Base
  attr_accessor :grant_member_ids
  attr_accessible :name, :message, :exp_points, :mineral_points, :picture_attributes, :grant_member_ids, :symbol

  has_many :points_obtains, class_name: Tracker::PointsObtain, as: :subject, dependent: :destroy
  has_one :picture, as: :subject, dependent: :destroy
  accepts_nested_attributes_for :picture

  def thumb_picture
    picture.file_url(:thumb)
  end

  def original_picture
    picture.file_url
  end

  def has_points?
    exp_points.present? or mineral_points.present?
  end

  def grant(members)
    members.each { |member| points_obtains.create(tracker_id: member.tracker_id, member_id: member.id) }
  end

end
