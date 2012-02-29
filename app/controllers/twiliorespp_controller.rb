class TwilioresppController < ApplicationController
  def answerMachine
    msg=params["Body"]
    number=params["From"]
    @resp=generate_response(msg,number)
    respond_to do |format|
      format.xml 
    end
  end
  
  def generate_response(msg,number)
    query= {"when" =>Date.today,"dur"  =>1,"atype" => nil}
    #authenticate
    array=msg.downcase.split
    student=Student.find_by_CellPhone(number)
    if student.nil?
      return "Sorry, I can't find you"
    end
    query["when"]=find_when(array)
    
    i = 0;
    while i < array.length  do
      if(array[i].eql?("week") && array[i-1].eql?("this"))
        query["dur"]=(7-Date.today.cwday)
      elsif(array[i].eql?("week") && array[i-1].eql?("next"))
        query["dur"]=7
        query["when"]=Date.today+(8-Date.today.cwday)
      end
      i+=1
    end
    #Find classname
    classids=find_classid(array,student)
    #Find type & number
    return "#{query["when"]}  #{query["dur"]}"
  end
  
  def find_classid(array, student)
    
  end
  def find_when(array)
    i = 0;
    while i < array.length  do
      if(array[i].eql?("today"))
        return Date.today
      end
      if(array[i].eql?("yesterday"))
        return Date.yesterday
      end
      if(array[i].eql?("dayaftertomorrow") || array[i].eql?("dayafter") || 
        (array[i].eql?("day") && array[i+1].eql?("after") ))
        return Date.today.tomorrow.tomorrow
      end
      if(array[i].eql?("tomorrow") || array[i].eql?("tom"))
        return Date.today.tomorrow
      end
      if(array[i].eql?("monday") || array[i].eql?("mon"))
        return day_date(1,array[i-1])
      end
      if(array[i].eql?("tuesday") || array[i].eql?("tues"))
        return day_date(2,array[i-1])
      end
      if(array[i].eql?("wednesday") || array[i].eql?("wed"))
        return day_date(3,array[i-1])
      end
      if(array[i].eql?("thursday") || array[i].eql?("thurs"))
        return day_date(4,array[i-1])
      end
      if(array[i].eql?("friday") || array[i].eql?("fri"))
        return day_date(5,array[i-1])
      end
      i+=1;
    end
    return Date.today
  end
  
  def day_date(day,nextday)
    tod=Date.today.cwday
    if(nextday=="next")
      day=day+7
    end
    if((day-tod)>=0)
      return Date.today+(day-tod)
    else
      return Date.today+(day-tod+7)
    end
  end
end
