class Achievement::Picture < Asset
  mount_uploader :file, AchievementPictureUploader
  validates :file, presence:true

end
