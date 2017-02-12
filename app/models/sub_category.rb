class SubCategory < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 50 }
  validates :style, presence: true, numericality: { greater_than: 0 }
  
  STYLE_SET = ["show", "other", "tool", "mod"]
  STYLE_SET.each_with_index do |sty, i|
    mask = 1 << i
    define_method("#{sty}?") do
      style & mask > 0
    end
    
    define_method("#{sty}") do
      self.style |= mask
    end
  end
end
