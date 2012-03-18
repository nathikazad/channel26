class Dept < ActiveRecord::Base
  attr_accessible :name
  has_many :simwords, :as => :simlable, :dependent => :destroy
  has_many :classrooms
end
