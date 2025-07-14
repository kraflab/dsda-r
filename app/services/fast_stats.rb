module FastStats
  def self.count_and_total_time(thing, with_cs = true)
    result = thing.demos.reorder(nil).pluck(Arel.sql('SUM(demos.tics), COUNT(*)')).first

    OpenStruct.new(
      demo_count: result[1],
      total_demo_time: Service::Tics::ToString.call(result[0] || 0, with_cs: with_cs)
    )
  end
end
