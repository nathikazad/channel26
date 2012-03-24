class Post < ActiveRecord::Base
  belongs_to :postable, :polymorphic => true
  has_many:posts ,:as => :postable, :dependent => :destroy
end
