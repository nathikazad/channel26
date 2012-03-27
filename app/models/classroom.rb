class Classroom < ActiveRecord::Base
  has_one :channel, :as => :channelable 
  attr_accessible :name
  belongs_to :dept
  has_many :assignments, :dependent => :destroy
  has_many :timeperiods, :as => :periodable, :dependent => :destroy
end
