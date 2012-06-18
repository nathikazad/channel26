class Assignment < ActiveRecord::Base
  attr_accessible :atype,:due_date
  belongs_to :classroom
  #has_many :grades, :dependent => :destroy
  #has_one :feeds ,:as => :feedable, :dependent => :destroy
end
