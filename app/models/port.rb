class Port < ApplicationRecord
  default_scope -> { order(:family, :version) }
  validates :family,  presence: true, length: { maximum: 50},
                      format: { with: VALID_userNAME_REGEX }
  validates :version, presence: true, length: { maximum: 50},
                      format: { with: VALID_VERSION_REGEX }
  validates :file,    length: { maximum: 50 }, allow_blank: true,
                      format: { with: VALID_USERNAME_REGEX }
  
  # Override path
  def to_param
    "#{family}:#{version}".downcase
  end
  
  def full_name
    return "#{family} #{version}"
  end
end
