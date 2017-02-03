module IwadsHelper
  
  def iwad_by_wad_count
    Hash[Iwad.all.map {|i| [i.name, i.wads.count]}]
  end
end
