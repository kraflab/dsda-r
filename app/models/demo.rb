class Demo < ApplicationRecord
  belongs_to :wad, touch: true
  belongs_to :category
  belongs_to :demo_file, autosave: true
  has_many :tags, dependent: :destroy
  has_many :sub_categories, through: :tags
  has_many :demo_players, dependent: :destroy
  has_many :players, through: :demo_players

  default_scope -> { order(:level, :category_id, :tics) }
  scope :movies, -> { reorder(:level).where("level LIKE 'Ep%' OR level LIKE '%A%'") }
  scope :ils, -> { reorder(:level).where("level NOT LIKE 'Ep%' AND level NOT LIKE '%A%'") }
  scope :show_movies, -> { where("level LIKE 'Ep%' OR level LIKE '%A%'") }
  scope :show_ils, -> { where("level NOT LIKE 'Ep%' AND level NOT LIKE '%A%'") }
  scope :episode, ->(ep) {
    reorder(:level).where("level <> ? AND (level LIKE ? or level = ? or LEVEL LIKE ? or LEVEL = ? #{ep == 2 ? 'or LEVEL = \'Map 31\' or LEVEL = \'Map 32\'' : ''})",
          "Map #{ep - 1}0", "Map #{ep - 1}_", "Map #{ep}0", "E#{ep}M%", "Ep #{ep}")
  }
  scope :recent, ->(n) { reorder(recorded_at: :desc).limit(n) }
  scope :within, ->(n) { reorder(recorded_at: :desc).where('recorded_at >= ?', n.days.ago)}
  scope :tas, -> { where('tas > 0') }

  validates :wad,       presence: true
  validates :category,  presence: true
  validates :players,   presence: true
  validates :demo_file, presence: true
  validates_associated :demo_file

  validates :tics,        presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :engine,      presence: true, length: { maximum: 50 }
  validates :tas,         presence: true,
                          numericality: { greater_than_or_equal_to: 0 }
  validates :guys,        presence: true, numericality: { greater_than: 0 }
  validates :version,     presence: true,
                          numericality: { greater_than_or_equal_to: 0 }
  validates :level,       presence: true, length: { maximum: 10 },
                          format: { with: VALID_PORT_REGEX }
  validates :levelstat,   length: { maximum: 500 }
  validates :compatibility, presence: true, numericality: { greater_than_or_equal_to: 0 }

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
    "#{coop_text} #{tas_text}"
  end

  def movie_text
    "#{players.first.name} #{time}"
  end

  def coop_text
    guys > 1 ? "#{guys}P" : ''
  end

  def tas_text
    tas != 0 ? (tas > 0 ? "T#{tas}" : 'T') : ''
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

  # Return true if fastest demo (including ties) *to the second*
  def is_record?
    Domain::Demo::ComputeRecordIndex.call(self).present?
  end

  # Number of slower demos for this run if it is a record (not record = 0)
  def record_index
    Domain::Demo::ComputeRecordIndex.call(self).to_i
  end

  private

  # collect names for table cell
  def cell_names(thing)
    thing.collect { |i| i.name }.join("\n")
  end
end
