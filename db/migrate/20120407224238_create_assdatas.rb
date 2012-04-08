class CreateAssdatas < ActiveRecord::Migration
  def self.up
    create_table :assdatas do |t|
      t.integer :atype
      t.integer :total
      t.integer :drop
      t.integer :out_of
      t.integer :p_of_a
      t.boolean :submit_online
      t.integer :classroom_id
      t.timestamps
    end
  end

  def self.down
    drop_table :assdatas
  end
end
