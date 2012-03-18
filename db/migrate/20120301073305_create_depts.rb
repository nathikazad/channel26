class CreateDepts < ActiveRecord::Migration
  def self.up
    create_table :depts do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :depts
  end
end
