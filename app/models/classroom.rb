class Classroom < ActiveRecord::Base
  attr_accessible :name
  belongs_to :teacher
  belongs_to :dept
  has_and_belongs_to_many :students
  has_many :assignments, :dependent => :destroy
  has_many :simwords, :as => :simlable, :dependent => :destroy
end
