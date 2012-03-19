class CreateChannelsStudents < ActiveRecord::Migration
  def self.up
    create_table :channels_students do |t|
      t.integer :channel_id
      t.string :channel_type
      t.integer :student_id
      t.timestamps
    end
  end

  def self.down
    drop_table :channels_students
  end
end
