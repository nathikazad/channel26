class TwilioresppController < ApplicationController
  def answerMachine
    @msg=params["Body"]
    number=params["From"]
    
    
    
    student=Student.find_by_CellPhone(number)
    @resp="#{student.first_name} #{student.last_name}, you are a faggot"
    
    #authenticate
    
    #Find when & duration#
    
    #Find classname
    
    #Find type & number
    
    
    respond_to do |format|
      format.xml 
    end
  end

end
