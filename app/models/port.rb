require 'callbacks/file_hash_callbacks'
class Port < ApplicationRecord
  default_scope -> { order(:family, :version) }
  validates :family,  presence: true, length: { maximum: 50},
                      format: { with: VALID_PORT_REGEX }
  validates :version, presence: true, length: { maximum: 50},
                      format: { with: VALID_VERSION_REGEX },
                      uniqueness: { scope: :family }
  validates :md5, presence: true, uniqueness: true
  mount_uploader :data, ZipFileUploader
  validates_presence_of :data
  validates_size_of :data, maximum: 100.megabytes, message: 'File exceeds 100 MB size limit'
  before_validation FileHashCallbacks.new
  before_save   :clean_strings
  before_update :clean_strings

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

  private

    # Remove excess whitespace
    def clean_strings
      self.family.strip.gsub!(/\s+/, ' ')
    end
end
