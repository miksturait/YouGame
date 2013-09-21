class Tracker::Level < ActiveRecord::Base
  attr_accessible :brood_name, :completed_at, :mineral_name, :month, :planet_name, :target, :tracker_id

  belongs_to :tracker
  has_many :points_obtains, through: :tracker, conditions: proc{"tracker_points_obtains.created_at >= '#{month.to_datetime.to_s(:db)}' and tracker_points_obtains.created_at <= '#{month.to_datetime.end_of_month.to_s(:db)}'"}

  validates :brood_name, :mineral_name, :planet_name, :target, :month, :tracker_id, presence: true
  validates :target, numericality: { greater_than: 0 }
  validates :month, format: { with: /[\d]{4}\-[\d]{2}/ }, uniqueness: { scope: :tracker_id }

  validates :planet_name, inclusion: { in: Game::PLANETS }, uniqueness: { scope: :tracker_id }
  validates :brood_name, inclusion: { in: Game::BROODS }
  validates :mineral_name, inclusion: { in: Game::MINERALS }

  scope :completed, ->() { where{completed_at.not_eq(nil)} }

  delegate :url, to: :tracker, prefix: :tracker

  %w(planet brood mineral).each do |type|
    define_method "#{type}_label" do
      I18n.t(self["#{type}_name"], scope: "#{type}_names")
    end

    define_method "#{type}_description" do
      I18n.t(self["#{type}_name"], scope: "#{type}_descriptions")
    end

    define_method "#{type}_image_path" do
      name = self["#{type}_name"]
      "/images/#{type}s/#{name}.jpg"
    end
  end

  def mineral_small_image_path
    "/images/minerals/small/#{mineral_name}.png"
  end

  def collected
    points_obtains.sum(:mineral_points)
  end

  def completed?
    completed_at.present?
  end

  def progress
    [(collected.to_f / target.to_f * 100).to_i, 100].min
  end

  def time_progress
    [(Date.today.day.to_f / month.end_of_month.day.to_f * 100).to_i, 100].min
  end

  def check_current_level
    update_attributes(completed_at: DateTime.now) if !completed? and collected >= target
  end

  class << self
    def available_planets_for(tracker)
      Game::PLANETS - tracker.levels.completed.map(&:planet_name)
    end

    def generate_target_for(tracker)
      last_level = tracker.levels.last
      target = (last_level and last_level.collected > 0) ? last_level.collected : 200000
      target = target * (100-rand(20)) / 100
      r = target % 100
      target - r
    end

    def generate_for(tracker)
      level               = self.new
      level.tracker_id    = tracker.id
      level.month         = Date.today.beginning_of_month
      level.planet_name   = available_planets_for(tracker).shuffle.first
      level.brood_name    = Game::BROODS.shuffle.first
      level.mineral_name  = Game::MINERALS.shuffle.first
      level.target        = generate_target_for(tracker)
      level.save
      level
    end
  end

end
