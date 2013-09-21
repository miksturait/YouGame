class Tracker::Report < ActiveRecord::Base
  attr_accessible :message, :project_id, :report_date

  belongs_to :tracker
  belongs_to :project
  belongs_to :creator, foreign_key: :creator_id, class_name: 'Tracker::Member'

  validates :tracker_id, :creator_id, :project_id, presence: true
  validates :report_date, uniqueness: {scope: [:tracker_id, :project_id]}
  validate :creator_is_project_lead

  delegate :name, to: :project, prefix: :project
  delegate :full_name, to: :creator, prefix: :creator

  def heading
    "Chief of <span class=\"important-text\">#{project_name}</span> unit reports:"
  end

  def message_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true)
    markdown.render(message)
  end

  def creator_avatar_small
    creator.avatar_url+"?s=#{40}"
  end

  private
  def creator_is_project_lead
    errors.add(:creator_id, :invalid) unless project.lead_member == creator
  end

end
