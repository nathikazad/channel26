class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.text :content
      t.integer :postable_id
      t.string :postable_type
      t.integer :score
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
