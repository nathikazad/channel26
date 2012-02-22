class TwilioresppController < ApplicationController
  def answerMachine
    @msg=params["Body"]
    number=params["From"]
    respond_to do |format|
      format.html # index.html.erb
      format.xml # index.xml.builder
    end
    
  end

end
