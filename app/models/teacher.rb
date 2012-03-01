class Teacher < ActiveRecord::Base
  has_many :classrooms
  has_many :simwords, :as => :simlable, :dependent => :destroy
end
