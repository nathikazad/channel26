class Classroom < ActiveRecord::Base
  attr_accessible :name
  belongs_to :teacher
  has_and_belongs_to_many :students
  has_many :assignments, :dependent => :destroy
  has_many :schedule, :dependent => :destroy
end
