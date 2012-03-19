class CreateChannelsStudents < ActiveRecord::Migration
  def self.up
    create_table :channels_students , :id => false do |t|
      t.integer :channel_id
      t.integer :student_id
      t.timestamps
    end
  end

  def self.down
    drop_table :channels_students
  end
end
