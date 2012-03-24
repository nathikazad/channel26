class Feed < ActiveRecord::Base
  has_many:posts ,:as => :postable, :dependent => :destroy
  belongs_to :feedable, :polymorphic => true
end
