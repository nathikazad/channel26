class Assignment < ActiveRecord::Base
  belongs_to :classsroom
  has_many :grades, :dependent => :destroy
  has_many :feeds ,:as => :feedable, :dependent => :destroy
end
