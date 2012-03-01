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
    array=(msg.downcase.split /[ _,-.''!?]|(\d+)/)
    array.delete("")
    student=Student.find_by_CellPhone(number)
    if student.nil?
      return "Sorry, I can't find you"
    end
    query["when"]=find_when(array)
    
    i = 0;
    while i < array.length  do
      if((similar(array[i],"week")>=75 && similar(array[i-1],"this")>=75) || similar(array[i],"thisweek")>=75)
        query["dur"]=(7-Date.today.cwday)
      elsif((similar(array[i],"week")>=75 && similar(array[i-1],"next")>=75) || similar(array[i],"nextweek")>=75)
        query["dur"]=7
        query["when"]=Date.today+(8-Date.today.cwday)
      end
      i+=1
    end
    #Find classname
    classids=find_classid(array,student)
    assignments=find_assignments(classids,array,student)
    #Find type & number
      #loop thru
      #check the assignment name and similar names (compare only with the length of the assignment type)
      #see if there is a number
    return "#{query["when"]}  #{query["dur"]} #{classids}"
  end
  
  def find_assignments(classids,array,student,)
    i=0
    ass=Array.new
    assi=0
    while i<classids.size
      j=0;
      while j<classids.size
        
        j=j+1;
      end
      i=i+1;
    end
  end
  
  def find_classid(array, student)
    stuclasses=student.classrooms
    classids=Array.new(stuclasses.length)
    j=0;
    while j < stuclasses.length  do
      i = 0;
      while i < array.length  do
        if((similar(array[i],stuclasses[j].department.downcase)>75) && 
          (is_not_a_number?(array[i+1]) || stuclasses[j].class_no==(array[i+1]) ))
          classids[j]=stuclasses[j]
        end
        i=i+1
      end
      j=j+1
    end
    return classids.compact
    #check with every single class's name and similar name
    #store ids in array where match
    #return array
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
  
  def is_not_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? true : false 
  end
end
