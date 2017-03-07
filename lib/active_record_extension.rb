module ActiveRecordExtension

  extend ActiveSupport::Concern

  # object too old to change certain fields (30 minutes)
  def is_frozen?
     ((Time.zone.now - created_at) / 60).to_i >= 30
  end
end

# include the extension 
ActiveRecord::Base.send(:include, ActiveRecordExtension)
