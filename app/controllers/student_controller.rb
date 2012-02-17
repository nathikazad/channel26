class StudentController < ApplicationController
  def register
    @title = "Register"
  end

  def login
    @user = User.new(params[:user])
    user = User.find_by_screen_name_and_password(@user.screen_name, @user.password)
    if user
      session[:user_id] = user.id
      flash[:notice] = "User #{user.screen_name} logged in"
      redirect_to :action => "index"
    else
      # Don't show the password in the view
      @user.password = nil
      flash[:notice] = "Invalid email/password combination"
    end
  end

end
