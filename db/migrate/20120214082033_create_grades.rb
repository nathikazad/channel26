class CreateGrades < ActiveRecord::Migration
  def self.up
    create_table :grades do |t|
      t.integer :score
      t.integer :assignment_id
      t.integer :student_id
      t.timestamps
    end
  end

  def self.down
    drop_table :grades
  end
end
