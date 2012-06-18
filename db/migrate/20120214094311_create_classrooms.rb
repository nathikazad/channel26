#feeds,links,course material
class CreateClassrooms < ActiveRecord::Migration
  def self.up
    create_table :classrooms do |t|
      
      t.string :class_no
      t.string :section_no
      t.string :institution
      t.integer :dept_id
      t.date :date_start
      t.date :date_end
      t.integer :assignment_size
      t.string :schedule
      t.text   :list
      t.text   :assarray
      t.timestamps
    end
  end

  def self.down
    drop_table :classrooms
  end
end
