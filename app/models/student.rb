class Student < ActiveRecord::Base
  attr_accessible :user_name,:password, :leftoverSMS
  has_and_belongs_to_many :channels
  has_many :grades
  has_many :posts ,:as => :poster, :dependent => :destroy
end
