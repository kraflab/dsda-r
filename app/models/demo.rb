class Demo < ApplicationRecord
  belongs_to :wad, touch: true
  belongs_to :category
  belongs_to :port
  has_many :tags, dependent: :destroy
  has_many :sub_categories, through: :tags
  has_many :demo_players, dependent: :destroy
  has_many :players, through: :demo_players
  default_scope -> { order(:level, :category_id) }
  validates :wad_id,      presence: true
  validates :category_id, presence: true
  validates :port_id,     presence: true
  validates :tics,        presence: true, numericality: { greater_than: 0 }
  validates :complevel,   presence: true
  validates :tas,         presence: true
  validates :guys,        presence: true, numericality: { greater_than: 0 }
  validates :has_tics,    presence: true
  validates :level,       presence: true, length: { maximum: 10 },
                          format: { with: VALID_PORT_REGEX }
  validates :recorded_at, presence: true
  validates :levelstat,   presence: true, length: { maximum: 500 }
  validates :file,    length: { maximum: 50 }, allow_blank: true,
                      format: { with: VALID_USERNAME_REGEX }
  after_save :update_players
  
  def file_path
    "#"
  end
  
  def time
    Demo.tics_to_string(tics)
  end
  
  def note
    "#{"C#{guys} " if guys > 1}#{"T#{tas}" if tas > 0}".strip
  end
  
  def port_text
    "#{port.full_name} #{complevel >= 0 ? "cl#{complevel}" : ""}"
  end
  
  def tags_text
    str = "Also "
    sub_categories.each do |tag|
      str += tag.name + " "
    end
    str
  end
  
  def players_text
    names = players.collect { |i| i.name }
    str = "#{names.shift}"
    names.each do |name|
      str += "\n#{name}"
    end
    str
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
  
  private
  
    # touch players when attributes change
    def update_players
      players.each { |i| i.touch }
    end
end
