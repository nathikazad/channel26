class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.integer  :serial
      t.integer  :atype
      # 0-class, 1-hw, 2-quiz, 3-mid term, 4-final
      t.datetime :assigned_date
      t.datetime :due_date
      t.string   :name
      t.text     :content
      t.string   :links
      t.string   :soln_links
      t.datetime :soln_release
      t.integer  :p_o_a #percent of assignment
      t.integer  :out_of
      t.integer  :classroom_id
      t.boolean  :submit_online
      t.boolean  :other_assignment
      t.string   :other_assgn_name
      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
