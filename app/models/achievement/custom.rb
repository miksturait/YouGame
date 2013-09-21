class Achievement::Custom < Achievement
  belongs_to :tracker
  validates :tracker_id, :symbol, presence: true
  validates :name, :message, presence: true
  validates :symbol, uniqueness: {scope: :tracker_id}

  def to_partial_path
    'custom_achievement'
  end
end
