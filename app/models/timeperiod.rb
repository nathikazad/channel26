class Timeperiod < ActiveRecord::Base
  belongs_to :periodable, :polymorphic => true
end
