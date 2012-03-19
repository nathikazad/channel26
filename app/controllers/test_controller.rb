class TestController < ApplicationController
@array=Array.new   #class variables are generally bad but it makes things drastically easier, so this is an exception
  def view1
    @array=("what hw due in computer sci").split /[ _,-.''!?]|(\d+)/
    garbage=delete_useless()
    @msg=find_classid(Student.find(1))
    #debugger
  end
  
  def find_classid(student)
    stuclasses=student.classrooms
    classids=Array.new(stuclasses.length)
    str=Array.new
    for i in 0..(@array.size-1)  do
      for j in 0..(stuclasses.size-1) do     
        sim=(stuclasses[j].dept.simwords | stuclasses[j].simwords )
        for k in sim do
          words=k.word.split
          str=str | words
          if(check4sim(words,i))
            if(is_a_number?(@array[i]))
              if(stuclasses[j].class_no.eql?(@array[i]) )
                @array.delete_at(i)
                classids[j]=stuclasses[j]
              end
            else
              classids[j]=stuclasses[j] 
            end
          end
        end
        #make it specific for classrooms
        if(similar(@array[i],stuclasses[j].teacher.first_name)>75||similar(@array[i],stuclasses[j].teacher.last_name)>75||
          similar(@array[i],("#{stuclasses[j].teacher.first_name}s"))>75||similar(@array[i],"#{stuclasses[j].teacher.last_name}s")>75)
          classids[j]=stuclasses[j]
          @array.delete_at(i)
        end
      end
    end
    #class_no
    
    return classids.compact
  end
  
  #limited by array2 max size = 2
  def check4sim(array2,i)
    str=""
    check=true
    for l in 0..(array2.size-1) do
      check=check && (similar(array2[l],@array[i+l])>75 )
      str.concat("#{array2[l]}")
    end
    
    if(check)

      for l in 0..(array2.size-1) do
        @array.delete_at(i)
      end
      return true
    end
    
    #clump all the words together and check
    if(similar(str,@array[i])>75 )
      @array.delete_at(i)
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
    useless=["is","are","","why","when","due","my","there","in","what"]
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
