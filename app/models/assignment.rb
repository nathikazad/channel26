class Assignment < ActiveRecord::Base
  belongs_to :classroom
  has_many :grades, :dependent => :destroy
  has_one :feeds ,:as => :feedable, :dependent => :destroy
end
