class TwilioresppController < ApplicationController
  def answerMachine
    @msg=params["Body"]
    number=params["From"]
    respond_to do |format|
      format.xml 
    end
    
    #student=Student.find_by_CellPhone(number)
   
    
    #authenticate
    
    #Find when & duration#
    
    #Find classname
    
    #Find type & number
    
    
    
  end

end
