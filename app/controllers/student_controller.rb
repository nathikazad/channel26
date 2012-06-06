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

  def newpost
  end

  def newcomment
    parent_id = Integer(params[:pid])
    text = params[:text]
    
    @post = Post.new
    @post.content = text
    @post.score = 0
    @post.postable_id = parent_id
    @post.postable_type = "Post"
    @post.poster_id = session[:user_id]
    @post.poster_type = session[:user_type]
    @post.save!
    render(:partial => "postedview", :locals => {:post => @post});
  end

  def profile
    if params[:type].eql?"Student"
      @person = Student.find(Integer(params[:id]));
    else
      @person = Teacher.find(Integer(params[:id]));
    end
    render(:partial => "profileview", :locals => {:person => @person});
  end

  def login
    if request.post?
      user = Student.find_by_username_and_password(params[:user][:username],params[:user][:password])
      if user
        session[:user_id] = user.id
	session[:user_type] = "Student"
        flash[:notice] = "User #{user.first_name} logged in"
        redirect_to :action => "index"
      else
	user = Teacher.find_by_username_and_password(params[:user][:username],params[:user][:password])
	if user
	  session[:user_id] = user.id
	  session[:user_type] = "Teacher"
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
    @msg=generate_response(@query,Student.find(session[:user_id]),false)
    render(:partial => "searchview", :locals => {:assignments => @msg, :query => @query});
  end

  def syllabus
    @student = Student.find(session[:user_id])
    @channel = @student.channels[Integer(params[:id])]
    type = Integer(params[:type])
    render(:partial => "syllabusview", :locals => {:type => type, :channel => @channel})
  end
  
  def dropbox
  @student = Student.find(session[:user_id])
  @channel = Channel.find(1)#@student.channels[Integer(params[:id])]
  @teacher = @channel.leader
  access_type = :app_folder
  boxval=Marshal.load(@teacher.dropbox)
  client = DropboxClient.new(boxval, access_type)
  file_metadata = client.metadata('/Math141')
  
  @msg= "#{file_metadata['contents']}"
  end
  s
end
