class Teacher < ActiveRecord::Base
  has_many :channels, :as => :leader 
  has_many :simwords, :as => :simlable, :dependent => :destroy
  has_many :posts ,:as => :poster, :dependent => :destroy
end
