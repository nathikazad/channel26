class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password
      t.string :email
      t.string :major
      t.string :CellPhone 
      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
