class CreateChannels < ActiveRecord::Migration
  def self.up
    create_table :channels do |t|
      t.string :name
      t.integer :leader_id
      t.string :leader_type
      t.integer :channelable_id
      t.string :channelable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :channels
  end
end
