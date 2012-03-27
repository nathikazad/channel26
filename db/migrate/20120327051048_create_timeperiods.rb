class CreateTimeperiods < ActiveRecord::Migration
  def self.up
    create_table :timeperiods do |t|
      t.string :day #monday=1 sunday=7 separted by .
      t.date    :date
      t.integer :start_hour
      t.integer :start_min
      t.integer :start_mer #am=0 pm=1
      t.integer :end_hour
      t.integer :end_min
      t.integer :end_mer #am=0 pm=1
      t.integer :periodable_id
      t.string  :periodable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :timeperiods
  end
end
