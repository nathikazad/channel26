class CreateClassroomsStudents < ActiveRecord::Migration
  def self.up
    create_table :classrooms_students , :id => false do |t|
      t.integer :classroom_id
      t.integer :student_id
      t.timestamps
    end
  end

  def self.down
    drop_table :classrooms_students
  end
end
