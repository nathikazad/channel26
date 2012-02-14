class Assignment < ActiveRecord::Base
  belongs_to :classsroom
  has_many :grades, dependent => :destroy
end
