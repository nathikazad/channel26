class TwilioresppController < ApplicationController
  def answerMachine
    msg=params["Body"]
    number=params["From"]
    number_to_send_to = "5309170565"
    student=Student.find_by_CellPhone(number)
    response = student.first_name
    twilio_sid = "ACfa79fe45769b4f4da3e379adbd6dae18"
    twilio_token = "6902d3f2f1648e586f8733dc849c1ef4"
    
    #authenticate
    
    #Find when & duration#
    
    #Find classname
    
    #Find type & number
    
    
    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token
    @twilio_client.account.sms.messages.create(
      :from => "4155992671",
      :to => params["From"],
      :body => response
    ) 
    
  end

end
