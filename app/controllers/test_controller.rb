class TestController < ApplicationController
@array=Array.new   #class variables are generally bad but it makes things drastically easier, so this is an exception
@i=0
  def view1
    @array=("hw 2 due in computer sci").split /[ _,-.''!?]|(\d+)/
    garbage=delete_useless()
    channels=Student.find(1).channels
    @msg=create_response([Channel.find(1).channelable.assignments.where(:serial => 1),nil],"is",Student.find(1))
  end
  
  def create_response(channelmaterial,first_word,student)
    resp=""
    if(first_word.eql?("do") || first_word.eql?("is") || first_word.eql?("any"))
      resp.concat("Yes you do on the following \n")
    end
    atypes=["Class","Homework","Quiz","Midterm","Final"]
    weekdays=["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    currdate = Date.new(2000)
    if (channelmaterial[0].size<=4)
      for i in 0..(channelmaterial[0].size-1) do
        if(!(currdate.eql?(channelmaterial[0][i].due_date)))
          if(channelmaterial[0][i].due_date.eql?(Date.today))
            resp.concat("Today \n")
          elsif(channelmaterial[0][i].due_date.eql?(Date.today+1))
            resp.concat("Tomorrow \n")
          elsif(Integer(channelmaterial[0][i].due_date-Date.today)<=4)
            resp.concat("#{weekdays[channelmaterial[0][i].due_date.cwday]} \n ")
          else
            resp.concat("#{channelmaterial[0][i].due_date.to_s} \n ")
          end
          currdate=channelmaterial[0][i].due_date
        end
        resp.concat("#{i+1}. #{atypes[channelmaterial[0][i].atype]} #{channelmaterial[0][1].serial} in #{channelmaterial[0][i].classroom.channel.name}\n ")
        resp.concat("#{channelmaterial[0][i].content} \n ")
      end
    else
      
    end
    return resp
  end
  
  def delete_useless()
    garbage=Array.new
    k=0
    useless=["is","are","","why","when","due","my","there","in","what","have","i","do","any"]
    for i in 0..(@array.size-1)
      for j in useless
        if(@array[i].eql?(j))
          garbage[k]=j
          k=k+1
          @array.delete_at(i)
        end
      end
    end
    return garbage
  end
end
