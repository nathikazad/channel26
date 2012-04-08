class AssignmentsController < ApplicationController
  
  #pass in the session[:user_id] and the index of the channel not the id
  #return @assignments, like @assignment[0] has an array of assignments with atype = 0, sorted in order of serial
  def view
    @student = Student.find(session[:user_id])
    @classroom = @student.classroom.find(params[:id])
    @assignments=Array.new
    for i in 0..4 do
      @assignments[i]=@classroom.assignments.where(:atype=>0).sort! {|a,b| a.serial <=> b.serial}
      @assignments[i].insert(0,nil) #so the indexes will match the serial
    end
  end
  
  #Call the update but make sure you set params[:assgnid], the id of the assignment to be chnaged,
  # and params[:assignment]. Lets say you change the due_date and content, first clear params[:assignment]
  # then set params[:assignment]["due_date"]=<new due_date> and set params[:assignment]["content"]=<the new content>
  def update
    @assignment=Assignment.find(params[:assgnid])
    @assignment.update_attributes(params[:assignment])
  end
  
  #make params[:assgnid] point to the id of the assignment to be deleted
  def destroy
    @assignment=Assignment.find(params[:assgnid])
    serial,atype=[@assignment.serial,@assignment.atype]
    @assignment.destroy
    
    assdata = @channel.assdata.find_by_atype(atype)
    assdata.total=assdata.total-1
    assdata.save
    
    @assignment[atype].delete_at(serial)
    
    while(serial<=assdata.total) do
      @assignments[atype][serial].serial=serial
      @assignments[atype][serial].save
      serial=serial+1
    end
    
  end

end
