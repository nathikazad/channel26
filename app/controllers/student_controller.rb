class StudentController < ApplicationController
  def register
    @title = "Register"
  end
  def index
    if !session[:user_id]
      redirect_to :action => "login"
    else
      @student=Student.find(session[:user_id]);
      @channels = @student.classrooms;
    end
  end

  def login
    if request.post?
      user = Student.find_by_username_and_password(params[:user][:username],params[:user][:password])
      if user
        session[:user_id] = user.id
        flash[:notice] = "User #{user.first_name} logged in"
        redirect_to :action => "index"
      else
        # Don't show the password in the view
        params[:user][:password] = nil
        flash[:notice] = "Invalid email/password combination"
      end
    end
  end

  def logout
    #destroy session variable here
    session[:user_id] = nil
    redirect_to student_login_url, :notice => 'logged out'
  end

end
