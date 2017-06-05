require 'callbacks/file_hash_callbacks'
class DemoFile < ApplicationRecord
  has_many :demos
  belongs_to :wad
  validates :wad_id, presence: true
  validates :md5, presence: true, uniqueness: true
  mount_uploader :data, ZipFileUploader
  validates_presence_of :data
  validates_size_of :data, maximum: 100.megabytes, message: 'File exceeds 100 MB size limit'
  before_validation FileHashCallbacks.new
end
