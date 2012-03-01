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
      if(similar(array[i],"week")>=75 && similar(array[i-1],"this")>=75)
        query["dur"]=(7-Date.today.cwday)
      elsif(similar(array[i],"week")>=75 && similar(array[i-1],"next")>=75)
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
      if(similar(array[i],"today")>=75)
        return Date.today
      end
      if(similar(array[i],"yesterday")>=75)
        return Date.today-1
      end
      if(similar(array[i],"dayaftertomorrow")>=75 || similar(array[i],"dayafter")>=75 || 
        (similar(array[i],"day")>=75 && similar(array[i+1],"after")>=75 ))
        return Date.today.tomorrow.tomorrow
      end
      if(similar(array[i],"tomorrow")>=75 || similar(array[i],"tom")>=75)
        return Date.today.tomorrow
      end
      if(similar(array[i],"monday")>=75 || similar(array[i],"mon")>=75)
        return day_date(1,array[i-1])
      end
      if(similar(array[i],"tuesday")>=75 || similar(array[i],"tues")>=75)
        return day_date(2,array[i-1])
      end
      if(similar(array[i],"wednesday")>=75 || similar(array[i],"wed")>=75)
        return day_date(3,array[i-1])
      end
      if(similar(array[i],"thursday")>=75 || similar(array[i],"thurs")>=75)
        return day_date(4,array[i-1])
      end
      if(similar(array[i],"friday")>=75 || similar(array[i],"fri")>=75)
        return day_date(5,array[i-1])
      end
      i+=1;
    end
    return Date.today
  end
  
  def day_date(day,nextday)
    tod=Date.today.cwday
    if(similar(nextday,"next")>=75)
      day=day+7
    end
    if((day-tod)>=0)
      return Date.today+(day-tod)
    else
      return Date.today+(day-tod+7)
    end
  end
  
  
  def similar(a,b)
     100-(Levenshtein.distance(a,b)*100/((a.length+b.length)/2))
  end
end
