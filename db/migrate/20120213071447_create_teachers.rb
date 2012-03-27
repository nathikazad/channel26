class CreateTeachers < ActiveRecord::Migration
  def self.up
    create_table :teachers do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password
      t.string :location
      t.string :department
      t.string :number
      t.timestamps
    end
  end

  def self.down
    drop_table :teachers
  end
end
