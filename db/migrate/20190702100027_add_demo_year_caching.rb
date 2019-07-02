class AddDemoYearCaching < ActiveRecord::Migration[5.0]
  def change
    add_column :demos, :year, :integer

    create_table :demo_years do |t|
      t.integer :year, null: false
      t.integer :count, default: 0

      t.timestamps
    end
    add_index :demo_years, :year, unique: true

    # Demo.in_batches do |demos|
    #   demos.each do |demo|
    #     demo.update(year: demo.recorded_at&.year)
    #     Domain::Demo::Year.increment(demo.recorded_at)
    #   end
    # end
  end
end
