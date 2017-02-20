class Demo < ApplicationRecord
  belongs_to :wad, touch: true
  belongs_to :category
  has_many :tags, dependent: :destroy
  has_many :sub_categories, through: :tags
  has_many :demo_players, dependent: :destroy
  has_many :players, through: :demo_players
  default_scope -> { order(:level, :category_id) }
  validates :wad_id,      presence: true
  validates :category_id, presence: true
  validates :tics,        presence: true, numericality: { greater_than: 0 }
  validates :engine,      presence: true, length: { maximum: 50 }
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
  
  def tags_text
    cell_names(sub_categories)
  end
  
  def players_text
    cell_names(players)
  end
  
  def self.tics_to_string(t, with_tics = true)
    s = t / 100
    t %= 100
    m = s / 60
    s %= 60
    h = m / 60
    m %= 60
    (h > 0 ? h.to_s + ":" + m.to_s.rjust(2, '0') : m.to_s) +
      ":#{s.to_s.rjust(2, '0')}" +
      (with_tics ? "." + t.to_s.rjust(2, '0') : "")
  end
  
  private
  
    # touch players when attributes change
    def update_players
      players.each { |i| i.touch }
    end
    
    # collect names for table cell
    def cell_names(thing)
      thing.collect { |i| i.name }.join("\n")
    end
end
