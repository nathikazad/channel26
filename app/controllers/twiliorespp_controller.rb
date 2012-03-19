class TwilioresppController < ApplicationController
@array=Array.new
@i=0
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
    @array=(msg.downcase.split /[ _,-.''!?]|(\d+)/)
    garbage=delete_useless()
    student=Student.find_by_CellPhone(number)
    if student.nil?
      return "Sorry, I can't find you"
    end
    
    #find when
    query["when"]=find_when()
    
    #for duration
    for @i in 0..@array.length-1  do
      if((similar(@array[@i],"week")>=75 && similar(@array[@i-1],"this")>=75) || similar(@array[@i],"thisweek")>=75)
        query["dur"]=(7-Date.today.cwday)
      elsif((similar(@array[@i],"week")>=75 && similar(@array[@i-1],"next")>=75) || similar(@array[@i],"nextweek")>=75)
        query["dur"]=7
        query["when"]=Date.today+(8-Date.today.cwday)
      end
    end
    
    #Find classname
    classids=find_classid(student)
    #assignments=find_assignments(classids,student)
    #Find type & number
      #loop thru
      #check the assignment name and similar names (compare only with the length of the assignment type)
      #see if there is a number
      #take note of the next word
    return "#{query["when"]}  #{query["dur"]} #{classids}"
  end
  
  def find_assignments(classids,student)
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
  
  def find_classid(student)
    stuchannels=student.channels
    classids=Array.new(stuchannels.length)
    str=Array.new
    #debugger
    @i=0
    while @i < @array.size  do
      for j in 0..(stuchannels.size-1) do     
        sim=(stuchannels[j].channelable.dept.simwords | stuchannels[j].simwords )
        for k in sim do
          words=k.word.split
          str=str | words
          if(check4sim(words))
            if(stuchannels[j].channelable_type.eql?("Classroom") && is_a_number?(@array[@i+1]))
              if(stuchannels[j].channelable.class_no.eql?(@array[@i+1]) )
                @array.delete_at(@i+1)
                classids[j]=stuchannels[j]
              end
            else
              classids[j]=stuchannels[j] 
            end
          end
        end
        #make it specific for classrooms
        if(stuchannels[j].channelable_type.eql?("Classroom") && (similar(@array[@i],stuchannels[j].leader.first_name)>75||similar(@array[@i],stuchannels[j].leader.last_name)>75||
          similar(@array[@i],("#{stuchannels[j].leader.first_name}s"))>75||similar(@array[@i],"#{stuchannels[j].leader.last_name}s")>75))
          classids[j]=stuchannels[j]
          @array.delete_at(@i)
          @i=@i-1
        end
      end
      @i=@i+1
    end
    for @i in 0..(@array.size-1)
      for j in 0..(stuchannels.size-1) do
        if(stuchannels[j].channelable.class_no.eql?(@array[@i]) )
          @array.delete_at(@i)
          @i=@i-1
          classids[j]=stuchannels[j]
        end
      end
    end
    
    return classids.compact
  end
  
  #limited by array2 max size = 2
  def check4sim(array2)
    str=""
    check=true
    for l in 0..(array2.size-1) do
      check=check && (similar(array2[l],@array[@i+l])>75 )
      str.concat("#{array2[l]}")
    end
    
    if(check)
      for l in 0..(array2.size-1) do
        @array.delete_at(@i)
        @i=@i-1
      end
      return true
    end
    
    #clump all the words together and check
    if(similar(str,@array[@i])>75 )
      @array.delete_at(@i)
      @i=@i-1
      return true
    end
    return false
  end
  
  def find_when()
    
    for @i in 0..(@array.length-1)  do
      if(similar(@array[@i],"today")>=75)
        @array.delete_at(@i)
        return Date.today
      end
      if(similar(@array[@i],"yesterday")>=75)
        @array.delete_at(@i)
        return Date.today-1
      end
      if(similar(@array[@i],"dayaftertomorrow")>=75 || similar(@array[@i],"dayafter")>=75 || 
        (similar(@array[@i],"day")>=75 && similar(@array[@i+1],"after")>=75 ))
        @array.delete_at(@i)
        return Date.today.tomorrow.tomorrow
      end
      if(similar(@array[@i],"tomorrow")>=75 || similar(@array[@i],"tom")>=75)
        @array.delete_at(@i)
        return Date.today.tomorrow
      end
      weekdays=[["monday","mon"],["tues","tuesday"],["wednesday","wed"],["thursday","thurs"],["friday","fri"],["saturday","sat"],["sunday","sun"]]
      for j in 0..(weekdays.size-1) do
        if(similar(@array[@i],weekdays[j][0])>=75 || similar(@array[@i],weekdays[j][1])>=75)
          @array.delete_at(@i)
          return day_date(j)
        end
      end
    end
    return Date.today
  end
  
  def day_date(day)
    tod=Date.today.cwday
    nextday=@array[@i-1]
    if(similar(nextday,"next")>=75)
      @array.delete_at(@i-1)
      return Date.today+(day+7)
    else
      return Date.today+(day)
    end
  end
  
  def similar(a,b)
    if(a.nil? || b.nil? ||(a.length+b.length<2 ))
      return 0
    end
    a=a.downcase
    b=b.downcase
    100-(Levenshtein.distance(a,b)*100/((a.length+b.length)/2))
  end
  
  def is_a_number?(s)
     s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
   end
  
   def delete_useless()
     garbage=Array.new
     k=0
     useless=["is","are","","why","when","due","my","there","in","on","what"]
     for i in 0..(@array.size-1)
       for j in useless
         if(@array[i].eql?(j))
           garbage[k]=j
           k=k+1
           @array.delete_at(i)
           i=i-1
         end
       end
     end
     return garbage
   end
end
