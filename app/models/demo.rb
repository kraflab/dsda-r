class Demo < ApplicationRecord
  belongs_to :player
  belongs_to :wad
  belongs_to :category
  belongs_to :port
  default_scope -> { order(:category_id, :level) }
  validates :player_id,   presence: true
  validates :wad_id,      presence: true
  validates :category_id, presence: true
  validates :port_id,     presence: true
  validates :tics,        presence: true, numericality: { greater_than: 0 }
  validates :cl,          presence: true
  validates :level,       presence: true, length: { maximum: 10 },
                          format: { with: VALID_PORT_REGEX }
  validates :recorded_at, presence: true
  validates :levelstat,   presence: true, length: { maximum: 500 }
  validates :file,    length: { maximum: 50 }, allow_blank: true,
                      format: { with: VALID_USERNAME_REGEX }
  
  def time
    Demo.tics_to_string(tics)
  end
  
  def self.tics_to_string(t)
    s = t / 100
    t %= 100
    m = s / 60
    s %= 60
    h = m / 60
    m %= 60
    str = m.to_s + ":" + s.to_s.rjust(2, '0') + "." + t.to_s.rjust(2, '0')
    h.to_s + ":" + str.rjust(6, '0') if h > 0
    str
  end
end
