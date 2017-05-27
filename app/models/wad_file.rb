class WadFile < ApplicationRecord
  has_many :wads
  belongs_to :iwad
  validates :iwad_id, presence: true
  validates :md5, presence: true, uniqueness: true
  mount_uploader :data, ZipFileUploader
  validates_size_of :data, maximum: 100.megabytes, message: 'File exceeds 100 MB size limit'
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
