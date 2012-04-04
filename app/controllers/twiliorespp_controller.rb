class TwilioresppController < ApplicationController
# 
# Description: We have one main method called generate response and two class variables @array and @i
#              they are made class variables because @array holds the filtered message from the user, 
#              and it is iterated many times through out the program to extract key information, so to
#              make it drastically easier while passing variables through multiple methods, they are made class variables.
#              "Its ok to break rules as long as we understand why they were made in the first place"
#
# Written by Nathik Azad for Channel26

  def answerMachine
    msg=params["Body"]
    number=params["From"]
    student=Student.find(1)#_by_CellPhone(number)
    if(msg.split.size>1)
      @resp=generate_response(msg,student,true)
    else
      @rep=retrieve(msg)
    end
    respond_to do |format|
      format.xml 
    end
  end
end
