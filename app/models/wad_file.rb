class WadFile < ApplicationRecord
  has_many :wads
  belongs_to :iwad
  validates :iwad_id, presence: true
  validates :base_path, presence: true
  validates :md5, presence: true, uniqueness: true
  mount_uploader :data, ZipFileUploader
  validates_presence_of :data
  validates_size_of :data, maximum: 200.megabytes, message: 'File exceeds 200 MB size limit'
end
