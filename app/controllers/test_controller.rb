class TestController < ApplicationController
@array=Array.new   #class variables are generally bad but it makes things drastically easier, so this is an exception
@i=0
  def view1
    @array=("hw 2 due in computer sci").split /[ _,-.''!?]|(\d+)/
    garbage=delete_useless()
    
    channels=Student.find(1).channels
    stuff=Array.new(2)
    stuff=find_stuff(channels,stuff)
    @msg=stuff
  end
  
  def find_stuff(channels, stuff)
    assignment_types=[["class","happened"],["hw","home work"],["quiz","test"],["mid term","test"],["final"]]
    clubs=Array.new
    classrooms=Array.new
    @i=0
    while @i < @array.size  do
      if(similar(@array[@i].singularize,"assignment")>75)
        classrooms=queryThat(classrooms,channels,nil,nil)
        @array.delete_at(@i)
        @i=@i-1
      else
        for j in 0..4 do
          for m in assignment_types[j] do
            words=m.split
            if(check4sim(words))
              if(is_a_number?(@array[@i+1]))
                classrooms=queryThat(classrooms,channels,j,@array[@i+1])
                @array.delete_at(@i+1)
                @i=@i-1
              else
                classrooms=queryThat(classrooms,channels,j,nil)
              end
            end
          end
        end
      end
      @i=@i+1
    end
    stuff[0]=classrooms
    stuff[1]=clubs
    return stuff
  end
  
  def queryThat(classrooms,channels,atype,serial)
    for k in 0..(channels.size-1) do
      if(channels[k].channelable_type.eql?("Classroom"))
        if(!(serial.nil?))
          classrooms=classrooms|channels[k].channelable.assignments.where(:atype => atype, :serial => serial)
        elsif(!(atype.nil?))
          classrooms=classrooms|channels[k].channelable.assignments.where(:atype => atype, :due_date => (Date.today-20)..Date.today)
        else
          classrooms=classrooms|channels[k].channelable.assignments.where(:due_date => (Date.today-20)..Date.today)
        end
      end
    end
    return classrooms
  end
  
  def check4sim(array2)
    str=""
    check=true
    for l in 0..(array2.size-1) do
      check=check && (similar(array2[l].singularize,@array[@i+l])>75 )
      str.concat("#{array2[l]}")
    end
    
    if(check)
      for l in 0..(array2.size-1) do
        @array.delete_at(@i)
        @i=@i-1
      end
      return true
    end
    
    #clump all the words together and check
    if(similar(str,@array[@i].singularize)>75)
      @array.delete_at(@i)
      @i=@i-1
      return true
    end
    return false
  end
  
  def similar(a,b)
    if(a.nil? || b.nil?)
      return 0
    end
    a=a.downcase
    b=b.downcase
    100-(Levenshtein.distance(a,b)*100/((a.length+b.length)/2))
  end
  
  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
  end
  
  def delete_useless()
    garbage=Array.new
    k=0
    useless=["is","are","","why","when","due","my","there","in","what","have","i","do","any"]
    for i in 0..(@array.size-1)
      for j in useless
        if(@array[i].eql?(j))
          garbage[k]=j
          k=k+1
          @array.delete_at(i)
        end
      end
    end
    return garbage
  end
end
