class Demo < ApplicationRecord
  belongs_to :wad, touch: true
  belongs_to :category
  belongs_to :demo_file
  has_many :tags, dependent: :destroy
  has_many :sub_categories, through: :tags
  has_many :demo_players, dependent: :destroy
  has_many :players, through: :demo_players
  default_scope -> { order(:level, :category_id, :tics) }
  scope :movies, -> { where("level LIKE 'Ep%' OR level LIKE 'A%'") }
  scope :ils, -> { where("level NOT LIKE 'Ep%' AND level NOT LIKE 'A%'") }
  validates :wad_id,      presence: true
  validates :category_id, presence: true
  validates :tics,        presence: true, numericality: { greater_than: 0 }
  validates :engine,      presence: true, length: { maximum: 50 }
  validates :tas,         presence: true,
                          numericality: { greater_than_or_equal_to: 0 }
  validates :guys,        presence: true, numericality: { greater_than: 0 }
  validates :version,     presence: true,
                          numericality: { greater_than_or_equal_to: 0 }
  #validates :has_tics,    presence: true
  validates :level,       presence: true, length: { maximum: 10 },
                          format: { with: VALID_PORT_REGEX }
  #validates :recorded_at, presence: true
  validates :levelstat,   length: { maximum: 500 }
  after_save    :update_players
  before_destroy :check_file
  after_destroy :update_players

  def wad_username
    wad.username if wad
  end

  def wad_username=(name)
    self.wad = Wad.find_by(username: name) unless name.blank?
    if wad.nil?
      errors.add(:wad_username, :not_found, message: "not found")
    end
  end

  def category_name
    category.name if category
  end

  def category_name=(name)
    self.category = Category.find_by(name: name) unless name.blank?
  end

  def file_path
    demo_file.data.url if demo_file
  end

  def time
    Demo.tics_to_string(tics, has_tics) if tics
  end

  # [hh:]mm:ss[.tt]
  def time=(str)
    return if str.blank?
    spl = str.split('.')
    fields = spl[0].split(':').reverse
    return if fields.count < 2
    self.tics = ( fields.count == 3 ? fields[2].to_i * 360000 : 0 ) +
                fields[1].to_i * 6000 + fields[0].to_i * 100 +
                ( spl.count == 2 ? spl[1].to_i : 0 )
    self.has_tics = (spl.count == 2)
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

  def update_tags
    self.has_hidden_tag = sub_categories.where('style & ? = 0', SubCategory.Show).exists?
    self.has_shown_tag = sub_categories.where('style & ? > 0', SubCategory.Show).exists?
    self.save
  end

  def hidden_tags_text
    cell_names(sub_categories.where('style & ? = 0', SubCategory.Show))
  end

  def shown_tags_text
    cell_names(sub_categories.where('style & ? > 0', SubCategory.Show))
  end

  def players_text
    cell_names(players)
  end

  # Return true if fastest demo (including ties) *to the second*
  def is_record?
    !record_index!.nil?
  end

  # Number of slower demos for this run if it is a record (not record = 0)
  def record_index
    record_index!.to_i
  end

  # Number of slower demos for this run if it is a record (not record = nil)
  def record_index!
    filter_categories = [category]
    if category.name == 'UV Speed' or category.name == 'SM Speed'
      filter_categories.push(Category.find_by(name: 'Pacifist'))
    end

    if best_of filter_categories
      filter_categories.pop if filter_categories.size > 1
      if category.name == 'Pacifist'
        filter_categories.push(Category.find_by(name: 'UV Speed'), Category.find_by(name: 'SM Speed'))
        # Only add these if the demo is faster (i.e., it is also the speed record)
        filter_categories.pop(2) if !best_of(filter_categories)
      end
      index_demos = Demo.where(wad: wad, level: level, category: filter_categories,
                               tas: tas, guys: guys)
      index_demos.count - 1
    else
      nil
    end
  end

  # Return true if demo is the fastest of this set
  def best_of(filter_categories)
    least_tics = Demo.where(wad: wad, level: level, category: filter_categories,
                             tas: tas, guys: guys).minimum(:tics)
    tics / 100 <= least_tics / 100
  end

  def self.tics_to_string(t, with_tics = true)
    s = t / 100
    t %= 100
    m = s / 60
    s %= 60
    h = m / 60
    m %= 60
    (h > 0 ? h.to_s + ':' + m.to_s.rjust(2, '0') : m.to_s) +
      ":#{s.to_s.rjust(2, '0')}" +
      (with_tics ? '.' + t.to_s.rjust(2, '0') : '')
  end

  def self.prune_levelstats
    Demo.all.each do |demo|
      if demo.time == demo.levelstat
        demo.levelstat = ''
        demo.save
      else
        if demo.levelstat.include? ','
          demo.levelstat = demo.levelstat.gsub(/,/, "\n")
          demo.save
        end
      end
    end
  end

  private

    # delete related file if this is the only associated demo
    def check_file
      if demo_file and demo_file.demos.count == 1
        temp = demo_file
        self.demo_file = nil
        self.save
        temp.destroy
      end
    end

    # touch players when attributes change
    def update_players
      players.each { |i| i.touch }
    end

    # collect names for table cell
    def cell_names(thing)
      thing.collect { |i| i.name }.join("\n")
    end
end
