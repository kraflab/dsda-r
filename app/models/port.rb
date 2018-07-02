class Port < ApplicationRecord
  validates :family,  presence: true, length: { maximum: 50},
                      format: { with: VALID_PORT_REGEX }
  validates :version, presence: true, length: { maximum: 50},
                      format: { with: VALID_VERSION_REGEX },
                      uniqueness: { scope: :family }
  validates :md5, presence: true, uniqueness: true
  mount_uploader :data, ZipFileUploader
  validates_presence_of :data
  validates_size_of :data, maximum: 100.megabytes, message: 'File exceeds 100 MB size limit'

  # Override path
  def to_param
    CGI::escape("#{family}:#{version}")
  end

  def full_name
    return "#{family} #{version}"
  end

  def file_path
    return data.url
  end
end
