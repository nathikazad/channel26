class CreateSimwords < ActiveRecord::Migration
  def self.up
    create_table :simwords do |t|
      t.integer :simlable_id
      t.string  :simlable_type
      t.string  :word
      t.timestamps
    end
  end

  def self.down
    drop_table :simwords
  end
end
