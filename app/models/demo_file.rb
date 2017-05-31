class DemoFile < ApplicationRecord
  has_many :demos
  belongs_to :wad
  validates :wad_id, presence: true
  validates :md5, presence: true, uniqueness: true
  mount_uploader :data, ZipFileUploader
  validates_presence_of :data
  validates_size_of :data, maximum: 1.megabytes, message: 'File exceeds 100 MB size limit'
  before_validation :compute_md5_hash

  private

    # Determine md5 hash for uniqueness test
    def compute_md5_hash
      self.md5 = if data and data.file and data.file.file
        Digest::MD5.hexdigest(data.file.read)
      else
        nil
      end
    end
end
