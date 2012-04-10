class AssignmentsController < ApplicationController
  
  #return @assignments, like @assignment[0] has an array of assignments with atype = 0, sorted in order of serial
  def viewassignments
    @classroom  = Classroom.find(Integer(params[:id]))
    @assignments= Array.new
    @assdata    = Array.new
    for i in 0..4 do
      @assignments[i]=@classroom.assignments.where(:atype=>0).sort! {|a,b| a.serial <=> b.serial}
      @assignments[i].insert(0,nil) #so the indexes will match the serial
      @assdata[i]=@classroom.assdatas.find_by_atype(0)
    end
    render(:partial => "viewassignments", :locals => {:assignments => @assignments, :assdata => @assdata});
  end
 
  def editassignment
    @assgn = Assignment.find(Integer(params[:id]))
    #add security to make sure teacher is leader of this class/assignment 
    render(:partial => "editassignment", :locals => {:assgn => @assgn});
  end

  # set the params[:assignment], which is a hash array and assign attributes like this
  # params[:assignment]["atype"]=0,params[:assignment]["content"]="blah blah blah"
  # make sure you dont set the serial and id
  def create
    @assignment=Assignment.new(params[:assignment])
    @assignments[@assignment.atype].push(@assignment)
    @assignments[@assignment.atype].delete_at(0)
    @assignments[@assignment.atype].sort! {|a,b| a.due_date <=> b.due_date}
    @assignments[@assignment.atype].insert(0,nil)
    
    assdata = @channel.assdata.find_by_atype(atype)
    assdata.total=assdata.total+1
    assdata.save
    
    for i in 1..assdata.total do
      @assignments[@assignment.atype][i].serial=i
      @assignments[@assignment.atype][i].save
    end
  end
  
  #Call the update but make sure you set params[:assgnid], the id of the assignment to be chnaged,
  # and params[:assignment]. Lets say you change the due_date and content, first clear params[:assignment]
  # then set params[:assignment]["due_date"]=<new due_date> and set params[:assignment]["content"]=<the new content>
  def update
    @assignment=Assignment.find(params[:assgnid])
    @assignment.update_attributes(params[:assignment])
    serial,atype=[@assignment.serial,@assignment.atype]
    while(@assignments[atype][serial+1].duedate < @assignments[atype][serial].duedate) do
      #switch vals and increment serial
      temp=@assignments[atype][serial]
      @assignments[atype][serial]=@assignments[atype][serial+1]
      @assignments[atype][serial].serial=serial
      @assignments[atype][serial].save
      serial=serial+1
      @assignments[atype][serial]=temp
      @assignments[atype][serial].serial=serial
    end
    while(@assignments[atype][serial-1].duedate > @assignments[atype][serial].duedate) do
      #switch vals and increment serial
      temp=@assignments[atype][serial]
      @assignments[atype][serial]=@assignments[atype][serial-1]
      @assignments[atype][serial].serial=serial
      @assignments[atype][serial].save
      serial=serial-1
      @assignments[atype][serial]=temp
      @assignments[atype][serial].serial=serial
    end
    @assignments[atype][serial].save
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
