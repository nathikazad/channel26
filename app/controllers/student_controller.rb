require 'uri'

class StudentController < ApplicationController
  def register
    @title = "Register"
  end

  def index
    if !session[:user_id]
      redirect_to :action => "login"
    else
      @student=Student.find(session[:user_id]);
      @channels = @student.channels;
    end
  end

  def infobox
    @student = Student.find(session[:user_id]);
    @channel = @student.channels[Integer(params[:id])];
    render(:partial => "infoview", :locals => {:channel => @channel});
  end

  def nutshell
    @student = Student.find(session[:user_id]);
    @channel = @student.channels[Integer(params[:id])];
    render(:partial => "nutshellview", :locals => {:channel => @channel});
  end

  def assignment
    @assign = Assignment.find(params[:id]);
    render(:partial => "assignmentview", :locals => {:assign => @assign});
  end

  def postview
    @post = Post.find(params[:id]);
    render(:partial => "postview", :locals => {:post => @post});
  end

  def upvote
    @post = Post.find(params[:id]);
    @post.score += 1
    @post.save!
    render(:partial => "upvoteview", :locals => {:post => @post});
  end

  def calendar
    @student = Student.find(session[:user_id]);
    @channel = @student.channels[Integer(params[:id])];
    render(:partial => "calendarview", :locals => {:channel => @channel});
  end

  def tabber
    @student = Student.find(session[:user_id]);
    @channel = @student.channels[Integer(params[:id])];
    render(:partial => "tabview", :locals => {:channel => @channel});
  end

  def login
    if request.post?
      user = Student.find_by_username_and_password(params[:user][:username],params[:user][:password])
      if user
        session[:user_id] = user.id
	session[:user_type] = "student"
        flash[:notice] = "User #{user.first_name} logged in"
        redirect_to :action => "index"
      else
	user = Teacher.find_by_username_and_password(params[:user][:username],params[:user][:password])
	if user
	  session[:user_id] = user.id
	  session[:user_type] = "teacher"
	  redirect_to :controller => "teacher", :action => "index"
	else
          # Don't show the password in the view
          params[:user][:password] = nil
          flash[:notice] = "Invalid email/password combination"
	end
      end
    end
  end

  def logout
    #destroy session variable here
    session[:user_id] = nil
    session[:user_type] = nil
    redirect_to student_login_url, :notice => 'logged out'
  end
  
  def search
    #ur gonna get the query from params[:query] do ur stuff in here
    @query = params[:query]
    @msg=generate_response(@query)
    render(:partial => "searchview", :locals => {:assignments => @msg, :query => @query});
  end

  def syllabus
    type = Integer(params[:type])
    render(:partial => "syllabusview", :locals => {:type => type});
  end
  
  @array=Array.new
  @i=0
  def generate_response(msg)
    
    #authenticate
    @array=(msg.downcase.split /[ _,-.''!?]|(\d+)/)
    garbage=delete_useless()
    student=Student.find(session[:user_id])
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
    
    return find_stuff(channels,start,(start+dur))
    
    #create readable response

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
