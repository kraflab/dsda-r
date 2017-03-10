class SubCategory < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :demos, through: :tags
  validates :name,  presence: true, length: { maximum: 50 }
  validates :style, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }

  STYLE_SET = ["show"]
  STYLE_SET.each_with_index do |sty, i|
    mask = 1 << i
    define_method("#{sty}?") do
      style & mask > 0
    end
    
    define_method("#{sty}=") do |on|
      on ? self.style |= mask : self.style &= ~mask
    end
    
    define_singleton_method("#{sty.capitalize}") do
      mask
    end
  end
end
