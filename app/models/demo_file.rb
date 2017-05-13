class DemoFile < ApplicationRecord
  has_many :demos
  belongs_to :wad
  validates :wad_id, presence: true
  validates :md5, presence: true, uniqueness: true
  mount_uploader :data, ZipFileUploader
  validates_size_of :data, maximum: 1.megabytes, message: 'File exceeds 1 MB size limit'
  before_validation :compute_md5_hash
  
  private
  
    # Determine md5 hash for uniqueness test
    def compute_md5_hash
      self.md5 = if data.file.file
        Digest::MD5.hexdigest(data.file.read)
      else
        nil
      end
    end
end