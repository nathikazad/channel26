class TeacherController < ApplicationController
  require 'dropbox_sdk'
  def index
    if !session[:user_id]
      redirect_to :action => "login", :controller => "student"
    else
      @teacher = Teacher.find(session[:user_id]);
      @channels = @teacher.channels;
    end
  end

  def infobox
    @teacher = Teacher.find(session[:user_id]);
    @channel = @teacher.channels[Integer(params[:id])];
    render(:partial => "infoview", :locals => {:channel => @channel});
  end

  def nutshell
    @teacher = Teacher.find(session[:user_id]);
    @channel = @teacher.channels[Integer(params[:id])];
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
    @teacher = Teacher.find(session[:user_id]);
    @channel = @teacher.channels[Integer(params[:id])];
    render(:partial => "calendarview", :locals => {:channel => @channel});
  end

  def tabber
    @teacher = Teacher.find(session[:user_id]);
    @channel = @teacher.channels[Integer(params[:id])];
    render(:partial => "tabview", :locals => {:channel => @channel});
  end

  def editassignment
    @assignments = Classroom.find(Integer(params[:id])).assignments;
    render(:partial => "editassignment", :locals => {:assignments => @assignments});
  end
  
  def dropbox
    app_key = 'zik2hns1iv3vyoy'
    app_secret = 'eb7lajdr7tua44l'
    session[:drop] = DropboxSession.new(app_key, app_secret)
    request_token=session[:drop].get_request_token
    redirect_to session[:drop].get_authorize_url("http://localhost:4000/teacher/dropbox_redirect")
  end
  
  def dropbox_redirect
    session[:drop].get_access_token
    access_type = :app_folder
    @teacher = Teacher.find(session[:user_id]);
    @teacher.dropbox=Marshal.dump(session[:drop])
    @teacher.dropbox=session[:drop].serialize
    @teacher.save
    session[:drop]=nil
  end

end
