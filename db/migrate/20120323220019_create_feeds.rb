class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :ftype
      t.integer :feedable_id
      t.string :feedable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
