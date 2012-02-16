#feeds,links,course material
class CreateClassrooms < ActiveRecord::Migration
  def self.up
    create_table :classrooms do |t|
      t.string :name
      t.integer :class_no
      t.integer :section_no
      t.string :institution
      t.string :department
      t.date :date_start
      t.date :date_end
      t.integer :teacher_id
      t.string :schedule
      t.timestamps
    end
  end

  def self.down
    drop_table :classrooms
  end
end
