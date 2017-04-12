atom_feed do |feed|
  feed.title "Latest demos"
  feed.updated @latest.try(:updated_at)
  
  @demos.each do |demo|
    feed.entry(demo) do |entry|
      entry.title "#{demo.wad_username} #{demo.level} #{demo.category_name} in #{demo.time}"
      entry.author do |author|
        author.name demo.players.map { |i| i.name }.join(',')
      end
    end
  end
end
