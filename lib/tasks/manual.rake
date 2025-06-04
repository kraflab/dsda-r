namespace :manual do
  desc "Update all records"
  task update_records: :environment do
    for demo in Domain::Demo.list() do
      Domain::Demo::UpdateRecordFields.call(demo)
    end
  end
end
