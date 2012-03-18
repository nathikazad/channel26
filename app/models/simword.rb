class Simword < ActiveRecord::Base
  belongs_to :simlable, :polymorphic => true
end
