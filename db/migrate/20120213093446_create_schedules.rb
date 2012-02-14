class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.string :day
      t.time :start
      t.time :end
      t.integer :classroom_id
      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
