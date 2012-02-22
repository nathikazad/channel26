class TwilioresppController < ApplicationController
  def answerMachine
    @msg=params["Body"]
    number=params["From"]
   
    
  end

end
