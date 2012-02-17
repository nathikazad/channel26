class Student < ActiveRecord::Base
  attr_accessible :user_name,:password
  has_and_belongs_to_many :classrooms
  has_many :grades
end
