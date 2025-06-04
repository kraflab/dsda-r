namespace :manual do
  desc "Update all records"
  task update_records: :environment do
    for demo in Domain::Demo.list() do
      Domain::Demo::UpdateRecordFields.call(demo)
    end

    for player in Domain::Player.list()
      Domain::Player.refresh_record_index(player: player)
    end
  end
end
