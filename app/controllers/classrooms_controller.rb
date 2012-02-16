class ClassroomsController < ApplicationController
  def show
    @classroom=Classroom.find(1)
  end

end
