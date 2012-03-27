class TeacherController < ApplicationController
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
    @teacher = Teacher.find(session[:user_id]);
    @channel = @teacher.channels[Integer(params[:id])];
    render(:partial => "editassignment", :locals => {:channel => @channel});
  end

end
