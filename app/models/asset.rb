class Asset < ActiveRecord::Base
  attr_accessible :file, :file_cache
  validates :file, presence: true
  belongs_to :subject, polymorphic: true
end
