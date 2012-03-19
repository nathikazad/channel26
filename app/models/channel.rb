class Channel < ActiveRecord::Base
  belongs_to :leader, :polymorphic => true
  belongs_to :channelable, :polymorphic => true
  has_and_belongs_to_many :students
  has_many :simwords, :as => :simlable, :dependent => :destroy
end
