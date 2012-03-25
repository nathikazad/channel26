class TwilioresppController < ApplicationController
# 
# Description: We have one main method called generate response and two class variables @array and @i
#              they are made class variables because @array holds the filtered message from the user, 
#              and it is iterated many times through out the program to extract key information, so to
#              make it drastically easier while passing variables through multiple methods, they are made class variables.
#              "Its ok to break rules as long as we understand why they were made in the first place"
#
# Written by Nathik Azad for Channel26
@array=Array.new
@i=0
  def answerMachine
    msg=params["Body"]
    number=params["From"]
    if(msg.split.size>1)
      @resp=generate_response(msg,number)
    else
      @rep=retrieve(msg)
    end
    respond_to do |format|
      format.xml 
    end
  end
  
  def query
    params[:assignmentids]=generate_response(params[:query],Student.find(session[:user_id]).CellPhone,false)
  end
  
  def generate_response(msg,number)
    
    #authenticate
    @array=(msg.downcase.split /[ _,-.''!?]|(\d+)/)
    garbage=delete_useless()
    student=Student.find_by_CellPhone(number)
    if student.nil?
      return "Sorry, I can't find you"
    end
    
    #find when
    start=find_when()
    
    #for duration
    if(start==nil)
      dur=5
      start=Date.today
    else
      dur=1
    end
    for @i in 0..@array.length-1  do
      if((similar(@array[@i],"week")>=75 && similar(@array[@i-1],"this")>=75)) 
        dur=(7-Date.today.cwday)
        @array.delete_at(@i)
        @array.delete_at(@i-1)
      elsif(similar(@array[@i],"thisweek")>=75)
        dur=(7-Date.today.cwday)
        @array.delete_at(@i)
      elsif((similar(@array[@i],"week")>=75 && similar(@array[@i-1],"next")>=75))
        dur=7
        start=Date.today+(8-Date.today.cwday) 
        @array.delete_at(@i)
        @array.delete_at(@i-1)
      elsif(similar(@array[@i],"nextweek")>=75)
        dur=7
        start=Date.today+(8-Date.today.cwday)
        @array.delete_at(@i)
      end
    end
    #Find channels
    if((channels=find_channels(student)).empty?)
      channels=student.channels
    end
    original=@array
    for @i in 0..(@array.size-1) do
      @array[@i]=@array[@i].singularize
    end

    #find channel related material
    
    channelmaterial=find_stuff(channels,start,(start+dur))
    
    #create readable response

    if(channelmaterial[0].size>0)
      return create_response(channelmaterial,garbage[0],student)
    else
      return "You dont have anything due till #{(start+dur)}"
    end
  end
  
  def create_response(channelmaterial,first_word,student)
    resp=""
    if(first_word.eql?("do") || first_word.eql?("is") || first_word.eql?("any"))
      resp.concat("Yes you do on the following \n")
    end
    atypes=["Class","Homework","Quiz","Midterm","Final"]
    weekdays=["","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    currdate = Date.new(2000)
   
    for i in 0..(channelmaterial[0].size-1) do
      if(!(currdate.eql?(channelmaterial[0][i].due_date)))
        if(channelmaterial[0][i].due_date.eql?(Date.today))
          resp.concat("Today \n")
        elsif(channelmaterial[0][i].due_date.eql?(Date.today+1))
          resp.concat("Tomorrow \n")
        elsif((diff=Integer(channelmaterial[0][i].due_date-Date.today))<=5 && diff>0)
          resp.concat("On #{weekdays[channelmaterial[0][i].due_date.cwday]} \n ")
        else
          resp.concat("On #{channelmaterial[0][i].due_date.to_s} \n ")
        end
        currdate=channelmaterial[0][i].due_date
      end
      resp.concat("#{i+1}. #{atypes[channelmaterial[0][i].atype]} #{channelmaterial[0][i].serial} in #{channelmaterial[0][i].classroom.channel.name}\n ")
      resp.concat("On #{channelmaterial[0][i].content} \n ")
    end
    return resp
  end
  
  def retrieve(word)
    
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
    return nil
  end
  
  def find_channels(student)
    stuchannels=student.channels
    channels=Array.new(stuchannels.length)
    @i=0
    while @i < @array.size  do
      for j in 0..(stuchannels.size-1) do     
        if(channels[j]==nil)
          sim=(stuchannels[j].channelable.dept.simwords | stuchannels[j].simwords )
          for k in sim do
            words=k.word.split
            if(check4sim(words))
              if(stuchannels[j].channelable_type.eql?("Classroom") && is_a_number?(@array[@i+1]))
                if(stuchannels[j].channelable.class_no.eql?(@array[@i+1]) )
                  @array.delete_at(@i+1)
                  channels[j]=stuchannels[j]
                end
              else
                channels[j]=stuchannels[j] 
              end
            end
          end
          #by teacher's name
          if(stuchannels[j].channelable_type.eql?("Classroom") && channels[j].nil? &&
            (similar(@array[@i],stuchannels[j].leader.first_name)>75||similar(@array[@i],stuchannels[j].leader.last_name)>75||
            similar(@array[@i],("#{stuchannels[j].leader.first_name}s"))>75||similar(@array[@i],"#{stuchannels[j].leader.last_name}s")>75))
            channels[j]=stuchannels[j]
            @array.delete_at(@i)
            @i=@i-1
          end
        end
      end
      @i=@i+1
    end
    for @i in 0..(@array.size-1)
      for j in 0..(stuchannels.size-1) do
        if(channels[j].nil? && stuchannels[j].channelable.class_no.eql?(@array[@i]) )
          @array.delete_at(@i)
          @i=@i-1
          channels[j]=stuchannels[j]
        end
      end
    end
    return channels.compact
  end
  
  def find_stuff(channels,start_date,end_date)
    stuff=Array.new(2)
    #test gets deleted
    assignment_types=[["class","happened"],["hw","home work"],["quiz"],["mid term"],["final"]]
    clubs=Array.new
    classrooms=Array.new
    @i=0
    while @i < @array.size  do
      for j in 0..4 do
        for m in assignment_types[j] do
          words=m.split
          if(check4sim(words))
            if(is_a_number?(@array[@i+1]))
              classrooms=classrooms | queryThat(channels,j,@array[@i+1],start_date,end_date,1)
              @array.delete_at(@i+1)
              @i=@i-1
            else
              limit=3
              if(@array[@i].eql?("next"))
                end_date=end_date+30
                limit=1
              elsif(@array[@i].eql?("all"))
                end_date=end_date+30
                limit=20
              end
              classrooms=classrooms | queryThat(channels,j,nil,start_date,end_date,limit)
            end
          end
        end
      end
      if(similar(@array[@i],"test")>75)
        classrooms=classrooms | queryThat(channels,2,nil,start_date,end_date,3)
        classrooms=classrooms | queryThat(channels,3,nil,start_date,end_date,3)
        classrooms=classrooms | queryThat(channels,4,nil,start_date,end_date,3)
        @array.delete_at(@i)
        @i=@i-1
      end
      if(similar(@array[@i],"exam")>75)
        classrooms=classrooms | queryThat(channels,3,nil,start_date,end_date,3)
        classrooms=classrooms | queryThat(channels,4,nil,start_date,end_date,3)
        @array.delete_at(@i)
        @i=@i-1
      end
      @i=@i+1
    end
    for @i in 0..(@array.size-1)
      if(similar(@array[@i],"assignment")>75 || similar(@array[@i],"anything")>75 || (classrooms.size==0 && similar(@array[@i],"due")>75 ) )
        classrooms=classrooms|queryThat(channels,nil,nil,start_date,end_date,3)
        @array.delete_at(@i)
        @i=@i-1
      end
    end
    stuff[0]=classrooms.sort! {|a,b| a.due_date <=> b.due_date}
    stuff[1]=clubs
    return stuff
  end
  
  def queryThat(channels,atype,serial,start_date,end_date,limit)
    classrooms=Array.new
    for k in 0..(channels.size-1) do
      if(channels[k].channelable_type.eql?("Classroom"))
        if(!(serial.nil?))
          classrooms=classrooms | channels[k].channelable.assignments.where(:atype => atype, :serial => serial).limit(limit)
        elsif(!(atype.nil?))
          classrooms=classrooms | channels[k].channelable.assignments.where(:atype => atype, :due_date => start_date..end_date).limit(limit)
        else
          classrooms=classrooms | channels[k].channelable.assignments.where(:due_date => start_date..end_date).limit(limit).find(:all, :conditions => ["atype != ?", 0])
        end
      end
    end
    return classrooms
  end
  
#  helper methods

  def check4sim(array2)
    str=""
    check=true
    for l in 0..(array2.size-1) do
      word=@array[@i+l]
      check=check && (similar(array2[l],word)>75 )
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
    word=@array[@i]
    if(similar(str,word)>75 )
      @array.delete_at(@i)
      @i=@i-1
      return true
    end
    return false
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
    #hack levenshtein to shorten runtime and make it scalable
    100-(Levenshtein.distance(a,b)*100/((a.length+b.length)/2))
  end
  
  def is_a_number?(s)
     s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
   end
  
   def delete_useless()
     #leave nil gaps
     garbage=Array.new
     k=0
     useless=["is","are","","when","my","there","in","on","what","have","i","do","any"]
     for i in 0..(@array.size-1)
       j=0
       while j < useless.size do  
         if(@array[i].eql?(useless[j]))
           garbage[k]=useless[j]
           k=k+1
           @array.delete_at(i)
           j=-1
         end
         j=j+1
       end
      end
      return garbage
   end
end
