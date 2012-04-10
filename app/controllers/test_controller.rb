class TestController < ApplicationController
@array=Array.new   #class variables are generally bad but it makes things drastically easier, so this is an exception
@i=0
  def view1
    @Student=Student.find(1)
  end
  
  def update
    stu=Student.find(1)
    debugger
    stu.update_attributes(params[:user])
  end
end
