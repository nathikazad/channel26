class TwilioresppController < ApplicationController
  def answerMachine
    msg=params["Body"]
    number=params["From"]
    student=Student.find_by_CellPhone(number)
    response = "#{student.first_name}, you are a fag"
    twilio_sid = "ACfa79fe45769b4f4da3e379adbd6dae18"
    twilio_token = "6902d3f2f1648e586f8733dc849c1ef4"
    
    #authenticate
    
    #Find when & duration#
    
    #Find classname
    
    #Find type & number
    
    
    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token
    @twilio_client.account.sms.messages.create(
      :from => "4155992671",
      :to => number
      :body => response
    ) 
    
  end

end
