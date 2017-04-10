class Port < ApplicationRecord
  default_scope -> { order(:family, :version) }
  validates :family,  presence: true, length: { maximum: 50},
                      format: { with: VALID_PORT_REGEX }
  validates :version, presence: true, length: { maximum: 50},
                      format: { with: VALID_VERSION_REGEX },
                      uniqueness: { scope: :family }
  validates :file,    length: { maximum: 50 }, allow_blank: true,
                      format: { with: VALID_USERNAME_REGEX }
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
    return '#'
  end
  
  private
  
    # Remove excess whitespace
    def clean_strings
      self.family.strip.gsub!(/\s+/, ' ')
    end
end
