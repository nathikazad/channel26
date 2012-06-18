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
    #add security to make sure teacher is leader of this class/assignment 
    teacher=@classroom.channel.leader
    access_type = :app_folder
    boxval=Marshal.load(teacher.dropbox)
    client = DropboxClient.new(boxval, access_type)
    @list=Array.new
    rip(client,"/#{@classroom.dept.name}#{@classroom.class_no}")
    render(:partial => "viewassignments", :locals => {:assignments => @assignments, :assdata => @assdata});
  end
 
  def editassignment
    @assgn = Assignment.find(Integer(params[:id]))
    render(:partial => "editassignment", :locals => {:assgn => @assgn, :all_paths => @list});
  end

  # set the params[:assignment], which is a hash array and assign attributes like this
  # params[:assignment]["atype"]=0,params[:assignment]["content"]="blah blah blah"
  # make sure you dont set the serial and id
  def create
  	if(request.post?)
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
  end
  
  #Call the update but make sure you set params[:assgnid], the id of the assignment to be chnaged,
  # and params[:assignment]. Lets say you change the due_date and content, first clear params[:assignment]
  # then set params[:assignment]["due_date"]=<new due_date> and set params[:assignment]["content"]=<the new content>
  def updateassignment
    @assignment=Assignment.find(params[:assgnid])
    a=@assignments
    @assignment.assigned_date=params[:assignment]["assigned_date"]
    @assignment.due_date=params[:assignment]["due_date"]
    @assignment.name=params[:assignment]["name"]
    @assignment.content=params[:assignment]["content"]
    @assignment.links=params[:assignment]["links"]
    @assignment.soln_links=params[:assignment]["soln_links"]
    @assignment.soln_release=params[:assignment]["soln_release"]
    @assignment.save
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
  	debugger
    @assignment=Assignment.find(Integer(params[:assignid]))
    serial,atype=[@assignment.serial,@assignment.atype]
    @assignment.destroy
    
    assdata = @channel.assdata.find_by_atype(atype)
    assdata.total=assdata.total-1
    assdata.save
    
    @assignments[atype].delete_at(serial)
    
    while(serial<=assdata.total) do
      @assignments[atype][serial].serial=serial
      @assignments[atype][serial].save
      serial=serial+1
    end
    render(:partial => "destroy");
  end
  
  # On the first call pass in class name as a params[classid] for example Math141 (one of the teacher's classes)
  # that'll return a list of all the paths in the folder at @list[index] and if it is a dir or not(boolean)
  # at @is_dir[index].
  # suppose a user clicks on a particular path and it is a folder then make params[path] equal to that path 
  # and call drop_down again, else save that path to the links attribute of the particular assignment
  
  def rip(client,path)
    file_metadata = client.metadata(path)
    for i in file_metadata["contents"] do
      if(i["is_dir"]==true)
        rip(client,i["path"])
      else
        @list.push(i["path"])
      end
    end
  end
end
