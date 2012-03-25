class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.text :content
      t.string :title
      t.integer :postable_id
      t.string :postable_type
      t.integer :score
      t.integer :poster_id
      t.string :poster_type
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
