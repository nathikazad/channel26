class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.string :name
      t.integer :type
      # 0-class, 1-hw, 2-quiz, 3-mid term, 4-final
      t.date :assigned_date
      t.date :due_date
      t.text :content
      t.integer :p_o_a #percent of assignment
      t.integer :out_of
      t.integer :classroom_id
      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
