class TwilioresppController < ApplicationController
array=Array.new
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
    #array=delete(array)
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
  
  def find_assignments(classids,array,student)
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
    for i in 0..(array.size-1)  do
      for j in 0..(stuclasses.size-1) do     
        sim=(stuclasses[j].dept.simwords | stuclasses[j].simwords )
        for k in sim do
          words=k.word.split
          if(words.size==1)
            if(similar(k.word,array[i])>75 )
              if(is_a_number?(array[i+1]) )
                 if(stuclasses[j].class_no.eql?(array[i+1]) )
                   classids[j]=stuclasses[j]
                   array.delete_at(i+1)
                   array.delete_at(i)
                 end
              else
                classids[j]=stuclasses[j]
                array.delete_at(i)
              end
            end
          else
            o=0
          end
        end
        if(similar(array[i],stuclasses[j].teacher.first_name)>75||similar(array[i],stuclasses[j].teacher.last_name)>75||
          similar(array[i],stuclasses[j].teacher.first_name.concat("s"))>75||similar(array[i],stuclasses[j].teacher.last_name.concat("s"))>75)
          classids[j]=stuclasses[j]
        end
        #class_no
      end
    end
    return classids.compact
  end

  def find_when(array)
    i = 0;
    #####implement forloop with array for checking
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
  
  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
  end
  
  def delete(array)
    useless=["is","are","","why","when","due","my","there","in"]
    for i in 0..(array.size-1)
      for j in useless
        if(array[i].eql?(j))
          array.delete_at(i)
        end
      end
    end
  end
end
