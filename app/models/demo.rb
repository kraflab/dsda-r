class Demo < ApplicationRecord
  belongs_to :wad, touch: true
  belongs_to :category
  belongs_to :demo_file, autosave: true
  has_many :tags, dependent: :destroy
  has_many :sub_categories, through: :tags
  has_many :demo_players, dependent: :destroy
  has_many :players, through: :demo_players

  default_scope -> { order(:level, :category_id, :tics) }
  scope :movies, -> { reorder(:level).show_movies }
  scope :ils, -> { reorder(:level).show_ils }
  scope :show_movies, -> { where("level LIKE 'Ep%' OR level LIKE '%All' OR level LIKE '%Movie'") }
  scope :show_ils, -> { where("level NOT LIKE 'Ep%' AND level NOT LIKE '%All' AND level NOT LIKE '%Movie'") }
  scope :episode, ->(ep) {
    reorder(:level, :category_id, :tics).where("level <> ? AND (level LIKE ? or level = ? or LEVEL LIKE ? or LEVEL = ? #{ep == 2 ? 'or LEVEL LIKE \'Map 31%\' or LEVEL = \'Map 32\'' : ''})",
          "Map #{ep - 1}0", "Map #{ep - 1}%", "Map #{ep}0", "E#{ep}M%", "Episode #{ep}")
  }
  scope :recent, ->(n) { reorder(recorded_at: :desc).limit(n) }
  scope :within, ->(n) { reorder(recorded_at: :desc).where('recorded_at >= ?', n.days.ago)}
  scope :tas, -> { where(tas: true) }
  scope :standard, -> { where(tas: false, guys: 1, solo_net: false) }
  scope :at_second, ->(n) { where('tics >= ? AND tics < ?', n * 100, (n + 1) * 100) }
  scope :only_records, -> { where("tic_record = 't' OR undisputed_record = 't'") }

  validates :wad,       presence: true
  validates :category,  presence: true
  validates :players,   presence: true
  validates :demo_file, presence: true
  validates_associated :demo_file

  validates :year, numericality: { greater_than: 1993 }, allow_nil: true
  validates :tics,        presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :engine,      presence: true, length: { maximum: 50 }
  validates :tas,         inclusion: [true, false]
  validates :guys,        presence: true, numericality: { greater_than: 0 }
  validates :version,     presence: true,
                          numericality: { greater_than_or_equal_to: 0 }
  validates :level,       presence: true, length: { maximum: 12 },
                          format: { with: VALID_PORT_REGEX }
  validates :levelstat,   length: { maximum: 500 }
  validates :compatible,  inclusion: [true, false]
  validates :record_index, presence: true, numericality: { greater_than_or_equal_to: 0 }

  delegate :name, to: :category, prefix: true

  def file_path
    demo_file.data.url if demo_file
  end

  def video_url
    "https://www.youtube.com/watch?v=#{video_link}" unless video_link.blank?
  end

  def time
    Service::Tics::ToString.call(tics, with_cs: has_tics) if tics
  end

  def time=(string)
    self.tics, self.has_tics = Service::Tics::FromString.call(string)
  end

  def note
    [
      coop_text,
      solo_net_text,
      tas_text
    ].compact.join("\n")
  end

  def movie_text
    "#{players.first.name} #{time}"
  end

  def coop_text
    "#{guys}P" if guys > 1
  end

  def tas_text
    'TAS' if tas
  end

  def solo_net_text
    'SN' if solo_net
  end

  def hidden_tags_text
    cell_names(sub_categories.hidden)
  end

  def shown_tags_text
    cell_names(sub_categories.shown)
  end

  def players_text
    cell_names(players)
  end

  def second
    tics / 100
  end

  def standard?
    guys == 1 && !tas? && !solo_net?
  end

  private

  # collect names for table cell
  def cell_names(thing)
    thing.collect { |i| i.name }.join("\n")
  end
end
